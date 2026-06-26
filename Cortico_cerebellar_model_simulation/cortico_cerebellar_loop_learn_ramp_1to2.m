%% cortico_cerebellar_loop_learn_ramp_1to2.m
% Cortico-cerebellar loop toy model in MATLAB
%
% Architecture:
%   readout/cortex r(t-1) + brief start pulse -> fixed random GC input weights
%   GC temporal basis: alpha-like temporal filtering with tau spanning 0.1-2 s
%   GC -> 2 PCs through trainable weights **using only LTD**
%   PC1 and PC2 are encouraged to ramp up and ramp down
%   PCs -> readout through fixed symmetric weights
%
% Training:
%   Stage 1: set up initial network to produce a 0-to-1 ramp over 1 s
%   Stage 2: training the GC->PC weights to produce a 0-to-1 ramp over 2 s
%
% Notes:
%   - Only GC->PC weights are trained.
%   - Stage 2 training only uses LTD at GC->PC weights
%   - Stage 1 still simulates to 2 s, but the loss is computed only from 0-1 s.
%
% Requires: MATLAB Deep Learning Toolbox for dlarray/dlgradient.

clear; close all; clc;
rng(1);

%% ---------------- Parameters ----------------
p = struct();

p.Ngc = 400;
p.dt = single(0.01);              % seconds
p.T  = single(2.0);               % seconds, simulation duration
p.t  = single(0:p.dt:p.T);
p.Nt = numel(p.t);

% GC alpha-filter time constants, sorted fast-to-slow.
% Draw from a range of 0.1-3 s.
tau = logspace(log10(0.1), log10(3.0), p.Ngc)';
p.tau = dlarray(single(tau));


% Fixed positive readout/cortex -> GC weights.
% Modeled as heterogeneous excitatory MF->GC strengths.
% CV = 0.46 follows the cerebellar GrC-weight heterogeneity used by
% Litwin-Kumar et al. based on Sargent et al. 2005.

cvWinGC = 0.46;

sigmaLog = sqrt(log(1 + cvWinGC^2));
muLog = -0.5 * sigmaLog^2;   % mean approximately 1 before normalization

rawWinGC = lognrnd(muLog, sigmaLog, p.Ngc, 1);

% Normalize RMS so total input scale stays comparable to the old version
rawWinGC = rawWinGC / rms(rawWinGC);

p.WinGC = dlarray(single(rawWinGC / sqrt(p.Ngc)));


% A short trigger pulse is needed to start the loop.
% Without a pulse or non-zero initial condition, the network remains silent.
p.startPulse = dlarray(single((p.t >= 0) & (p.t < 0.05)));

% Relative gain of recurrent readout feedback into GCs.
p.feedbackGain = dlarray(single(0.40));

% Nonlinear gains.
p.gcGain = dlarray(single(1.0));
p.pcGain = dlarray(single(1.0));

% PC -> readout fixed symmetric weights.
% readout = outputGain*PC1 - outputGain*PC2.
p.outputGain = dlarray(single(0.65));

% Regularization.
p.l2 = dlarray(single(1e-4));

% Training parameters.
nEpochStage1 = 400;   % train to 1-s ramp
nEpochStage2 = 400;   % adapt to 2-s ramp

learnRate = single(0.03);
beta1 = single(0.9);
beta2 = single(0.999);
adamEps = single(1e-8);

target2s = targetRamp(p.t, single(2.0));
target1s = targetRamp(p.t, single(1.0));

% For 1-s ramp learning, the model is still simulated to 2 s, but only
% the first second contributes to the training loss. After 1 s, the
% target function is treated as ended rather than as a plateau to fit.
lossWeight1s = single(p.t <= 1.0);
lossWeight1s = lossWeight1s ./ sum(lossWeight1s);
lossWeight1s = dlarray(lossWeight1s);

%% ---------------- Trainable weights ----------------
% Only one GC -> PC vector is trained.
% each PC recieves separate theta (GC->PC weights)
% Because the two PC to downstream readout have identify weight with 
% opposite sign, this encourages mirror-image PCs. To generate a ramp
% in the readout, the two PCs will naturally ramp up and down with proper
% initialization
thetaInit = single(0.01 * randn(2,p.Ngc));

thetaInit(1,:) =  abs(thetaInit(1,:));   % bias PC1 toward ramping up
thetaInit(2,:) = -abs(thetaInit(2,:));   % bias PC2 toward ramping down

theta = dlarray(thetaInit);

% Adam optimizer state.
m = dlarray(zeros(size(theta),'single'));
v = dlarray(zeros(size(theta),'single'));
globalStep = 0;


%% ---------------- Storage for plotting ----------------
% Take snapshots at specific epochs
snapEpochs1 = [1 3 5 50 200 400];
snapEpochs2 = [1 3 5 50 200 400];

snap = struct();
snap.stage = {};
snap.epoch = [];
snap.r = {};
snap.gc = {};
snap.pc = {};
snap.theta = {};
snap.loss = [];

lossStage1 = zeros(nEpochStage1,1);
lossStage2 = zeros(nEpochStage2,1);

theta0 = extractdata(theta);

%% ---------------- Stage 1: train 1-s ramp ----------------
fprintf('Training stage 1: 1-s ramp target...\n');
% This is the initial training stage for setting up the network to have a ramp.
% No constraints are imposed on GC->PC weights during Stage 1.
% The model is simulated to 2 s, but only the first 1 s contributes to loss.

for epoch = 1:nEpochStage1
    globalStep = globalStep + 1;

    [loss, grad] = dlfeval(@modelGradients, theta, target1s, p, lossWeight1s);
    lossStage1(epoch) = double(extractdata(loss));

    [theta, m, v] = adamUpdate(theta, grad, m, v, globalStep, learnRate, beta1, beta2, adamEps);

    if ismember(epoch, snapEpochs1)
        [r, gc, pc] = forwardModel(theta, p);
        snap = addSnapshot(snap, '1-s target', epoch, r, gc, pc, theta, loss);
    end
end

thetaStage1 = extractdata(theta);


%% ---------------- Stage 2: retrain/adapt to 2-s ramp ----------------
% This is the within-session delay learning stage.
% The weight change for Stage 2 learning is constrained to be negative,
% to model LTD only.
fprintf('Training stage 2: 2-s ramp target, LTD only...\n');

% Store Stage 1 weights as the upper bound for Stage 2.
% During Stage 2, each GC->PC weight can only decrease from this value.
thetaUpper = dlarray(single(thetaStage1));

for epoch = 1:nEpochStage2
    globalStep = globalStep + 1;

    [loss, grad] = dlfeval(@modelGradients, theta, target2s, p);
    lossStage2(epoch) = double(extractdata(loss));

    % Standard Adam update
    [thetaCandidate, m, v] = adamUpdate(theta, grad, m, v, ...
        globalStep, learnRate, beta1, beta2, adamEps);

    % Projected constraint:
    % only allow weights to decrease relative to Stage 1.
    theta = min(thetaCandidate, thetaUpper);

    if ismember(epoch, snapEpochs2)
        [r, gc, pc] = forwardModel(theta, p);
        snap = addSnapshot(snap, '2-s target', epoch, r, gc, pc, theta, loss);
    end
end

thetaFinal = extractdata(theta);


%% ---------------- Final model responses ----------------
[r1, gc1, pc1] = forwardModel(dlarray(thetaStage1), p);
[r2, gc2, pc2] = forwardModel(theta, p);

r1 = extractdata(r1);
gc1 = extractdata(gc1);
pc1 = extractdata(pc1);

r2 = extractdata(r2);
gc2 = extractdata(gc2);
pc2 = extractdata(pc2);

%% ---------------- Plot 1: readout response ----------------
figure('Color','w','Position',[100 100 1000 420]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

nexttile;
hold on;
target1sPlot = extractdata(target1s);
target1sPlot(p.t > 1.0) = NaN;
plot(p.t, target1sPlot, 'k--', 'LineWidth', 2);
for i = 1:numel(snap.epoch)
    if strcmp(snap.stage{i}, '1-s target')
        plot(p.t, extractdata(snap.r{i}), 'LineWidth', 1);
    end
end
xlabel('Time (s)');
ylabel('Readout activity');
title('Readout Stage 1: learning 1-s ramp');
ylim([0 1])
xlim([0 2])
xline(1.0, 'k:', 'Loss ends');
legend(['Target', compose('epoch %d', snapEpochs1), 'loss cutoff'], 'Location','southeast');
box off;

nexttile;
semilogy(lossStage1, 'LineWidth', 1.5); 
xlabel('Epoch');
ylabel('MSE + L2 loss');
title('Training loss');
box off;


% **stage 2 - this is the stage to focus on
figure('Color','w','Position',[480  250  560 450]); hold on
plot(p.t, target1sPlot, '--', 'color',[.7 .7 .7], 'LineWidth', 2);
plot(p.t, extractdata(target2s), 'k--', 'LineWidth', 2);
for i = 1:numel(snap.epoch)
    if strcmp(snap.stage{i}, '2-s target')
        plot(p.t, extractdata(snap.r{i}), 'LineWidth', 1);
    end
end
xlabel('Time (s)');
ylabel('Readout activity');
title('Readout Stage 2: adapting to 2-s ramp');
ylim([0 1])
xlim([0 2])
legend(['Prev Target', 'New Target', compose('epoch %d', snapEpochs2)], 'Location','southeast');
box off;

%% ---------------- Plot 2: GC responses ----------------
% GC responses are normalized to peak.
tauGC = extractdata(p.tau);
[sortedTau, sortIdx] = sort(tauGC, 'ascend');

gc1Plot = gc1;
gc2Plot = gc2;

gc1Plot = gc1Plot./repmat(max(gc1Plot,[],2),1,size(gc1Plot,2));
gc2Plot = gc2Plot./repmat(max(gc2Plot,[],2),1,size(gc2Plot,2));

maxGC = max([gc1Plot(:); gc2Plot(:)]);

figure('Color','w','Position',[100 100 1050 420]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

nexttile;
imagesc(p.t, 1:p.Ngc, gc1Plot(sortIdx,:));
axis xy;
caxis([0 maxGC]);
xlabel('Time (s)');
ylabel('GC time constant \tau (s)');
title('GC activity at 1-s delay (before learning)');
colorbar;
formatTauYAxis(sortedTau, p.Ngc);

nexttile;
imagesc(p.t, 1:p.Ngc, gc2Plot(sortIdx,:));
axis xy;
caxis([0 maxGC]);
xlabel('Time (s)');
ylabel('GC time constant \tau (s)');
title('GC activity after learning 2-s delay');
colorbar;
formatTauYAxis(sortedTau, p.Ngc);

%% ---------------- Plot 3: PC responses ----------------
figure('Color','w','Position',[100 100 1000 420]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

nexttile;
plot(p.t, pc1(1,:), 'LineWidth', 2); hold on;
plot(p.t, pc1(2,:), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('PC activity');
title('PCs at 1-s delay (before learning)');
legend('PC1','PC2','Location','best');
box off;

nexttile;
plot(p.t, pc2(1,:), 'LineWidth', 2); hold on;
plot(p.t, pc2(2,:), 'LineWidth', 2);
plot(p.t, pc1(1,:), 'k:'); 
plot(p.t, pc1(2,:), 'k:');
xlabel('Time (s)');
ylabel('PC activity');
title('PCs after learning 2-s delay');
legend('PC1','PC2','Location','best');
box off;

%% ---------------- Plot 4: GC->PC weights and Stage 2 weight change ----------------
% Top: GC->PC weight magnitudes before and after Stage 2 learning.
% Bottom: Stage 2 weight change only.
%
% Concatenated order:
%   x = 1:400   : GC->PC1, ranked by GC tau
%   x = 401:800 : GC->PC2, ranked by GC tau

tauGC = extractdata(p.tau);

% Rank GCs by tau
[sortedTau, sortIdx] = sort(tauGC, 'ascend');

% thetaStage1 and thetaFinal are 2 x Ngc
%   row 1: GC -> PC1
%   row 2: GC -> PC2

% Weight magnitudes
wStage1_PC1 = thetaStage1(1,:);
wStage1_PC2 = thetaStage1(2,:);

wFinal_PC1 = thetaFinal(1,:);
wFinal_PC2 = thetaFinal(2,:);

% Sort by GC tau
wStage1_PC1_sorted = reshape(wStage1_PC1(sortIdx), 1, []);
wStage1_PC2_sorted = reshape(wStage1_PC2(sortIdx), 1, []);

wFinal_PC1_sorted = reshape(wFinal_PC1(sortIdx), 1, []);
wFinal_PC2_sorted = reshape(wFinal_PC2(sortIdx), 1, []);

% Concatenate PC1 and PC2
wStage1_concat = [wStage1_PC1_sorted, wStage1_PC2_sorted];
wFinal_concat  = [wFinal_PC1_sorted,  wFinal_PC2_sorted];

% Stage 2 weight change
deltaW = thetaFinal - thetaStage1;

deltaW_PC1 = deltaW(1,:);
deltaW_PC2 = deltaW(2,:);

% Sort by GC tau
deltaW_PC1_sorted = reshape(deltaW_PC1(sortIdx), 1, []);
deltaW_PC2_sorted = reshape(deltaW_PC2(sortIdx), 1, []);

% Concatenate PC1 and PC2 weight changes
deltaW_concat = [deltaW_PC1_sorted, deltaW_PC2_sorted];

% Plot
xVals = 1:(2*p.Ngc);

figure('Color','w','Position',[100 100 950 620]);
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

% Top subplot: weight magnitudes
nexttile;
plot(xVals, wStage1_concat, 'LineWidth', 1.5); hold on;
plot(xVals, wFinal_concat,  'LineWidth', 1.5);
xline(p.Ngc + 0.5, 'k--');

ylabel('|GC-PC weight|');
title('GC-PC weight magnitude before and after Stage 2 learning');
legend('After 1-s learning', 'After 2-s learning', 'Location','best');
box off;
xlim([1, 2*p.Ngc]);

xticks([1, p.Ngc, p.Ngc+1, 2*p.Ngc]);
xticklabels({'PC1 GC1', sprintf('PC1 GC%d', p.Ngc), ...
             'PC2 GC1', sprintf('PC2 GC%d', p.Ngc)});

yl = ylim;
yText = yl(2) - 0.08 * range(yl);

text(p.Ngc/2, yText, 'GC \rightarrow PC1', ...
    'HorizontalAlignment','center');

text(p.Ngc + p.Ngc/2, yText, 'GC \rightarrow PC2', ...
    'HorizontalAlignment','center');

% Bottom subplot: weight change
nexttile;
plot(xVals, deltaW_concat, 'LineWidth', 1.5);
hold on;

yline(0, 'k--');
xline(p.Ngc + 0.5, 'k--');

xlabel('GC number ranked by \tau');
ylabel('\Delta GC-PC weight');
title('Stage 2 weight change: 1-s ramp to 2-s ramp');
box off;
xlim([1, 2*p.Ngc]);

xticks([1, p.Ngc, p.Ngc+1, 2*p.Ngc]);
xticklabels({'PC1 GC1', sprintf('PC1 GC%d', p.Ngc), ...
             'PC2 GC1', sprintf('PC2 GC%d', p.Ngc)});

yl = ylim;
yText = yl(2) - 0.08 * range(yl);

text(p.Ngc/2, yText, 'GC \rightarrow PC1', ...
    'HorizontalAlignment','center');

text(p.Ngc + p.Ngc/2, yText, 'GC \rightarrow PC2', ...
    'HorizontalAlignment','center');


%% ---------------- Plot 5: GC impulse responses sorted by tau --------------
% This visualizes the open-loop GC temporal basis functions.
% It uses the final model's fixed readout->GC weights and GC taus.
% Negative-going responses are inverted so all responses are positive-going.
pImp = p;

% Use a longer window to visualize slow tau units.
pImp.T  = single(4.0);
pImp.t  = single(0:pImp.dt:pImp.T);
pImp.Nt = numel(pImp.t);

% Define open-loop impulse input to GCs.
pImp.corticalInput = dlarray(single([1, zeros(1, pImp.Nt-1)]));

% startPulse and feedbackGain no longer matter because corticalInput exists,
% but setting these to zero avoids confusion.
pImp.startPulse = dlarray(zeros(1, pImp.Nt, 'single'));
pImp.feedbackGain = dlarray(single(0));

% theta does not affect GC activity in open-loop mode,
% but forwardModel still needs it to compute PCs/readout.
[~, gcImp, ~] = forwardModel(theta, pImp);

gcImp = extractdata(gcImp);
tauImp = extractdata(pImp.tau);

% Normalize each GC to its own peak to show temporal profile.
gcImpNorm = normalizeRowsByPeak(gcImp);

% Sort by tau.
[sortedTauImp, sortIdxImp] = sort(tauImp, 'descend');

figure('Color','w','Position',[100 100 700 600]);
imagesc(pImp.t, 1:pImp.Ngc, gcImpNorm(sortIdxImp,:));
axis xy;
xlabel('Time after impulse (s)');
ylabel('GC time constant \tau (s)');
title('GC impulse responses sorted by \tau');
colorbar;
formatTauYAxis(sortedTauImp, pImp.Ngc);

%% ================= Local functions =================

function y = targetRamp(t, rampDuration)
    y = single(t ./ rampDuration);
    y(y > 1) = 1;
    y = dlarray(y);
end

function [loss, grad] = modelGradients(theta, target, p, lossWeight)
    [r, ~, ~] = forwardModel(theta, p);

    if nargin < 4 || isempty(lossWeight)
        mse = mean((r - target).^2, 'all');
    else
        mse = sum(lossWeight .* (r - target).^2, 'all');
    end

    reg = p.l2 * mean(theta.^2, 'all');
    loss = mse + reg;

    grad = dlgradient(loss, theta);
end

function [r, gc, pc] = forwardModel(theta, p)
    % Differentiable forward simulation.
    %
    % GC filter implementation:
    % The alpha filter h(t)=t/tau*exp(-t/tau) is implemented as two cascaded
    % first-order filters with the same tau:
    %   x1' = (-x1 + u) / tau
    %   x2' = (-x2 + x1) / tau
    % x2 is proportional to an alpha-function response.
    %
    % If p.corticalInput exists, forwardModel runs in open-loop mode for
    % the GC layer. Otherwise, it runs in closed-loop mode.

    x1 = dlarray(zeros(p.Ngc,1,'single'));
    x2 = dlarray(zeros(p.Ngc,1,'single'));

    r = dlarray(zeros(1,p.Nt,'single'));
    gc = dlarray(zeros(p.Ngc,p.Nt,'single'));
    pc = dlarray(zeros(2,p.Nt,'single'));

    rPrev = dlarray(single(0));

    for k = 1:p.Nt
        % Scalar cortical/readout signal sent to all GCs.
        if isfield(p, 'corticalInput')
            % Open-loop mode: directly provide the cortical/readout input to GCs.
            corticalSignal = p.corticalInput(k);
        else
            % Closed-loop mode: default trained network dynamics.
            corticalSignal = p.startPulse(k) + p.feedbackGain * rPrev;
        end

        % Fixed random input into each GC.
        u = p.WinGC * corticalSignal;

        % Alpha-like temporal filtering.
        x1 = x1 + p.dt * (-x1 + u) ./ p.tau;
        x2 = x2 + p.dt * (-x2 + x1) ./ p.tau;

        gcNow = tanh(p.gcGain * x2);

        % Independent GC -> PC weights.
        % theta is now 2 x Ngc.
        pcDrive = theta * gcNow;          % 2 x 1

        pcNow = tanh(p.pcGain * pcDrive);

        pc1 = pcNow(1);
        pc2 = pcNow(2);

        % Fixed symmetric PC -> readout weights.
        % PC1 contributes positively; PC2 contributes negatively.
        rNow = p.outputGain * pc1 - p.outputGain * pc2;

        gc(:,k) = gcNow;
        pc(:,k) = pcNow;
        r(k) = rNow;

        rPrev = rNow;
    end
end

function [param, m, v] = adamUpdate(param, grad, m, v, t, lr, beta1, beta2, epsVal)
    m = beta1*m + (1-beta1)*grad;
    v = beta2*v + (1-beta2)*(grad.^2);

    mHat = m ./ (1 - beta1^t);
    vHat = v ./ (1 - beta2^t);

    param = param - lr * mHat ./ (sqrt(vHat) + epsVal);
end

function snap = addSnapshot(snap, stage, epoch, r, gc, pc, theta, loss)
    snap.stage{end+1} = stage;
    snap.epoch(end+1) = epoch;
    snap.r{end+1} = r;
    snap.gc{end+1} = gc;
    snap.pc{end+1} = pc;
    snap.theta{end+1} = theta;
    snap.loss(end+1) = double(extractdata(loss));
end

function yNorm = normalizeRowsByPeak(y)
    peakVal = max(y, [], 2);
    yNorm = y ./ peakVal;
    yNorm(isnan(yNorm)) = 0;
    yNorm(isinf(yNorm)) = 0;
end

function formatTauYAxis(sortedTau, nRows)
    yt = round(linspace(1, nRows, 6));
    yticks(yt);
    yticklabels(arrayfun(@(i) sprintf('%.2f', sortedTau(i)), yt, ...
        'UniformOutput', false));
end
