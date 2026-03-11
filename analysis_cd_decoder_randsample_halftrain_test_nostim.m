clear all
close all


addpath('./func/')
addpath('functions\')
cur_dir = pwd;


%%
load analysis_decoder_ALMprojTH_units_trainCorrect_sampledelay_20251126.mat


keyboard

%% organize result from individual session (pool trials together across sessions, use single run)
time_bins = -3.5:.01:-0.2;
group_num = 6;
i_round = 2;% round 1 for ALM recording; round2 for ALM_projecting TH
min_trl_cut = 5; %min 5 trial in the bin
x_rng = -2:.2:2;

sel_session = cellfun(@(x) x(i_round),decoder_perf_allSession)>0.6;

cd_ramp_corr = cellfun(@(x) corr(x{i_round}(:,1),x{i_round}(:,2)),w_LDA_allSession(sel_session));
disp('mean');mean(cd_ramp_corr,1)
disp('sme'); std(cd_ramp_corr,[],1) / sqrt(length(cd_ramp_corr))
% EP_CD vs lick
[~,EP_CD_lick_curve] = func_compute_EP_CD_vs_lick_pooltrials(x_rng,EP_CD_ctrl_allSession(sel_session,1),trials_allSession(sel_session,1),i_round,min_trl_cut);
figure();hold on;
patch([x_rng flip(x_rng)],[sum(EP_CD_lick_curve,2);flip(diff(EP_CD_lick_curve(:,[2 1]),1,2))],[0.5 0.5 0.5],'EdgeColor','none','facealpha',0.2);
plot(x_rng,EP_CD_lick_curve(:,1),'k')
xlabel('CD (a.u.)');xlim([-2 2]);xticks([-2:1:2])
ylabel('Fractoin of lick right');ylim([0 1])
set(gca,'TickDir','out','Box','off')

% EP_CD histo curve
% histo_curve = (x_rng,y_c/n_c/y_e/n_e,mean/std);
histo_curve = func_compute_EP_CD_histo_curve_pooltrials(x_rng,EP_CD_ctrl_allSession(sel_session,1),i_round); 

% EP_CD vs RT (ALLtrl/Ltrl/Rtrl）
[~,EP_CD_RT_curve] = func_compute_EP_CD_vs_RT_pooltrials(x_rng,EP_CD_ctrl_allSession(sel_session,1),trials_allSession(sel_session,1),RT_allSession(sel_session,1),i_round,min_trl_cut);
figure();hold on;
patch([x_rng flip(x_rng)],[sum(EP_CD_RT_curve(:,:,1),2);flip(diff(EP_CD_RT_curve(:,[2 1],1),1,2))],[0.5 0.5 0.5],'EdgeColor','none','facealpha',0.2);
plot(x_rng,EP_CD_RT_curve(:,1,1),'k')
xlabel('CD (a.u.)');xlim([-2 2]);xticks([-2:1:2])
ylabel('\Delta reaction time (s)');
set(gca,'TickDir','out','Box','off')

%% ramping related
[EP_ramp_ctrl_allSession2,trajectory_ramp_ctrl_allSession2] = func_normalize_ramp_base_amplitude(trajectory_ramp_alltrl_allSession,trials_allSession,time_bins);% regenerate EP_ramp_ctrl_allSession, normed ramp will be (ramp-base)/amplitude


%% ramping vs lick dir (right lick
x_rng = 0:.25:2;
[X_all,EP_ramp_lick_curve] = func_compute_EP_ramp_vs_lick_pooltrials(x_rng,EP_ramp_ctrl_allSession2(sel_session,1),trials_allSession(sel_session,1),i_round,min_trl_cut);
figure();hold on;
patch([0:0.25:2 flip(0:0.25:2)],[sum(EP_ramp_lick_curve(:,:,1),2); flip(diff(EP_ramp_lick_curve(:,[2,1],1),1,2))],[0.8 0.8 0.8],'EdgeColor','none','facealpha',0.5)
plot([0:0.25:2],EP_ramp_lick_curve(:,1,1),'k')
xlabel('ramp (a.u.)');xlim([0 2]);xticks([0 1 2]);
ylabel('Fractoin of lick right');ylim([0 1]);yticks([0 .5 1])
set(gca,'TickDir','out','Box','off')

%% ramping vs RT
RT_cutoff = 0.5;
% [ramp_all,EP_ramp_RT_curve] = func_group_EP_ramp_pooltrials([0:0.25:2],EP_ramp_ctrl_allSession2(sel_session,1),trials_allSession(sel_session,1),RT_allSession(sel_session,1),i_round,group_num,min_trl_cut,RT_cutoff);
[ramp_all,EP_ramp_RT_curve] = func_group_EP_ramp_pooltrials([0:0.25:2],EP_ramp_ctrl_allSession2(sel_session,1),trials_allSession(sel_session,1),RT_video_allSession(sel_session,1),i_round,group_num,min_trl_cut,RT_cutoff);


% % this section plots trace, same as RT vs CD curve
% figure();hold on; 
% patch([0:0.25:2 flip(0:0.25:2)],[EP_ramp_RT_curve(:,1,1)+EP_ramp_RT_curve(:,2,1); flip(EP_ramp_RT_curve(:,1,1)-EP_ramp_RT_curve(:,2,1))],[0.8 0.8 0.8],'EdgeColor','none','facealpha',0.5)
% plot([0:0.25:2],EP_ramp_RT_curve(:,1,1),'k')
% xlabel('ramp (a.u.)');xlim([0 2]);xticks([0 1 2])
% ylabel('\Delta reaction time (s)');
% set(gca,'TickDir','out','Box','off')

% this section plots errorbars, same as ramp vs RT, but x-y axis flipped
figure();hold on;
x_avg = ramp_all(:,1,1);
x_std = ramp_all(:,2,1);
y_avg = EP_ramp_RT_curve(:,1,1);
y_std = EP_ramp_RT_curve(:,2,1);

errorbar(x_avg,y_avg,y_std,y_std,x_std,x_std,'LineStyle','none','LineWidth',1)
xlabel('ramp (a.u.)')
ylabel('Reaction time (s)')
set(gca,'TickDir','out','Box','off')

%% % ramping trace
% ramp_trace = func_group_traceramp_pooltrials(0:0.25:2,trajectory_ramp_ctrl_allSession2(sel_session,1),EP_ramp_ctrl_allSession2(sel_session,1),i_round,group_num);
RT_cutoff = 0.5;

ramp_trace = func_group_tracramp_pooltrials_baseRT(trajectory_ramp_ctrl_allSession2(sel_session,1),RT_allSession(sel_session,1),trials_allSession(sel_session,1),i_round,group_num,RT_cutoff);
i_t = time_bins<-0.2;
a = turbo;
colors = a(1:floor(256/size(ramp_trace,1)):256,:);

figure();hold on;
for i_grp = 1 : size(ramp_trace,1)
    patch([time_bins(i_t),flip(time_bins(i_t))],[ramp_trace(i_grp,i_t,1)+ramp_trace(i_grp,i_t,2) flip(ramp_trace(i_grp,i_t,1)-ramp_trace(i_grp,i_t,2))],colors(i_grp,:),'edgecolor','none','facealpha',0.2)
    plot(time_bins(i_t),ramp_trace(i_grp,i_t,1),'color',colors(i_grp,:))
end
plot([0 0],[-0.1 1.2],'linewidth',1,'Color','k')
plot([-1.3 -1.3],[-0.1 1.2],'linewidth',1,'Color','k')
plot([-2.6 -2.6],[-0.1 1.2],'linewidth',1,'Color','k')
xlim([-3 0.2])
ylim([-0.1 1.2])
xticks([-2.6 -1.3 0])
xlabel('time from go cue (s)')
ylabel('Activity projection on ramping mode (a.u.)')
set(gca,'TickDir','out','box','off')

%%
% ramping vs CD
x_rng = round(0:0.25:2,2);
[EP_ramp_group1,EP_cd_group1,EP_ramp_group2,EP_cd_group2] = func_compute_EP_ramp_vs_EP_CD_pooltrials([0:0.25:2],EP_CD_ctrl_allSession(sel_session,1),EP_ramp_ctrl_allSession2(sel_session,1),trials_allSession(sel_session,1),i_round,min_trl_cut);

figure();hold on;
errorbar(EP_ramp_group1(:,1),EP_cd_group1(:,1),EP_cd_group1(:,2),EP_cd_group1(:,2),EP_ramp_group1(:,2),EP_ramp_group1(:,2),'.','Color','r','MarkerSize',20,'LineWidth',1)
errorbar(EP_ramp_group2(:,1),EP_cd_group2(:,1),EP_cd_group2(:,2),EP_cd_group2(:,2),EP_ramp_group2(:,2),EP_ramp_group2(:,2),'.','Color','b','MarkerSize',20,'LineWidth',1)
xlabel('ramp (a.u.)');xlim([0 2]);xticks([0 1 2])
ylabel('CD (a.u.)');yticks([-2:1:2])
set(gca,'TickDir','out','Box','off')




%% variance distribution
var_dist_sampledelay = cell([]);
n = 1;
for i_sess = 1 : size(activity_matrix_allSession,1)
    if ismember(i_sess,find(sel_session))
    cur_activity_matrix = activity_matrix_allSession{i_sess,1};
    cur_trials = trials_allSession{i_sess,1}(i_round,:);
    cur_w_LDA = w_LDA_allSession{i_sess,1}{i_round,1};

        activityRL_train = cat(2,mean(cur_activity_matrix(:,:,cur_trials{3}),3),mean(cur_activity_matrix(:,:,cur_trials{4}),3));
        activityRL_test = cat(2,mean(cur_activity_matrix(:,:,cur_trials{5}),3),mean(cur_activity_matrix(:,:,cur_trials{6}),3));
        var_allDim_sampledelay = func_compute_var(activityRL_train,activityRL_test,cur_w_LDA,[-2.6 0]);
        
        var_dist_sampledelay{n,1} = mean(var_allDim_sampledelay,1,'omitmissing');
        n = n+1;
    end
end

figure()
hold on;title('sample+delay')
maxlen = max(cellfun(@length, var_dist_sampledelay));
data_pad = cellfun(@(x) [x nan(1, maxlen-length(x))], var_dist_sampledelay, 'UniformOutput', false);
data_mat = vertcat(data_pad{:});
func_plot_bar_with_err(data_mat(:,1:10),[0.5 0.5 0.5],'sme')
xticks([1 2 6]);xticklabels({'choice';'ramping';'rest PCs'});xtickangle(45)
set(gca,'TickDir','out','Box','off')

%%
% example session + correct error trial, histo plot
i_session = 47; % 49 for alm session; 47 for ALM-projecting TH
time_bins = [-3.5:0.01:1]+0.1;
figure('position',[200 200 900 500])
subplot(1,5,[1 2 3]);hold on;title('example session')
line([-2.6 -2.6],[-120 120],'color','k')
line([-1.3 -1.3],[-120 120],'color','k')
line([-0 -0],[-120 120],'color','k')
xx1 = cat(1,trajectory_CD_ctrl_allSession{i_session,1}{i_round,1},trajectory_CD_ctrl_allSession{i_session,1}{i_round,4});
xx1 = (xx1 - DP_scaling_allSession{i_session,1}(i_round,1)) /DP_scaling_allSession{i_session,1}(i_round,2);
xx2 = cat(1,trajectory_CD_ctrl_allSession{i_session,1}{i_round,2},trajectory_CD_ctrl_allSession{i_session,1}{i_round,3});
xx2 = (xx2 - DP_scaling_allSession{i_session,1}(i_round,1)) /DP_scaling_allSession{i_session,1}(i_round,2);

a=plot(time_bins,xx1','color','b');
b=plot(time_bins,xx2,'color','r');
xlim([-3.5 1.5]);xticks([-3:1]);xlabel('time aligned to go (s)')
ylim([-1 2.5]);yticks([-2 -1 0 1 2]);ylabel('Acitivty projection (a.u.)')
legend([a(1), b(1)],{'lick right','lick left'},'box','off')
set(gca,'TickDir','out','Box','off')

subplot(1,5,4);hold on;title('correct')
patch([-2:.2:2 flip(-2:.2:2)],[histo_curve(:,1,1)+histo_curve(:,1,2);flip(histo_curve(:,1,1)-histo_curve(:,1,2))],[.4 .4 .7],'edgecolor','none')
patch([-2:.2:2 flip(-2:.2:2)],[histo_curve(:,2,1)+histo_curve(:,2,2);flip(histo_curve(:,2,1)-histo_curve(:,2,2))],[.7 .4 .4],'edgecolor','none')
plot([-2:.2:2],histo_curve(:,1,1),'b')
plot([-2:.2:2],histo_curve(:,2,1),'r')

% session based plot
% func_plot_mean_and_sem(-2:0.2:2,histo_curve(:,:,1),'b',[.4 .4 .7],'none',1);
% func_plot_mean_and_sem(-2:0.2:2,histo_curve(:,:,2),'r',[.7 .4 .4],'none',1);
xlim([-2 2]);xticks([-2 0 2]);xlabel('Acitivty projection (a.u.)')
ylim([0 6]);yticks([0 6]);ylabel('% of trials')
view([90 -90])
set(gca,'TickDir','out','Box','off')

subplot(1,5,5);hold on;title('error')
patch([-2:.2:2 flip(-2:.2:2)],[histo_curve(:,3,1)+histo_curve(:,3,2);flip(histo_curve(:,3,1)-histo_curve(:,3,2))],[.4 .4 .7],'edgecolor','none')
patch([-2:.2:2 flip(-2:.2:2)],[histo_curve(:,4,1)+histo_curve(:,4,2);flip(histo_curve(:,4,1)-histo_curve(:,4,2))],[.7 .4 .4],'edgecolor','none')
plot([-2:.2:2],histo_curve(:,3,1),'b')
plot([-2:.2:2],histo_curve(:,4,1),'r')

% session based plot
% func_plot_mean_and_sem(-2:0.2:2,histo_curve(:,:,3),'b',[.4 .4 .7],'none',1);
% func_plot_mean_and_sem(-2:0.2:2,histo_curve(:,:,4),'r',[.7 .4 .4],'none',1);
xlim([-2 2]);xticks([-2 0 2]);xlabel('Acitivty projection (a.u.)')
ylim([0 2]);yticks([0 2]);yticklabels([0 2]);ylabel('% of trials')
view([90 -90])
set(gca,'TickDir','out','Box','off')




%% decoder performance vs individual mouse difference

mice = unique(extractBefore(session_name(:,2),'_'));
x_color = turbo;
x_color = x_color(1 : floor(size(x_color,1)/length(mice)) : end,:);

figure()
for i_stim = 1 : 2
    subplot(2,2,2*i_stim-1);hold on;
    idx = decoder_perf_summary(:,1,i_stim)>0.7& repeat_num(:,i_stim)>=8;
    % idx = ismember(session_name(:,2),good_sessions);
    for i_mice = 1 : length(mice)
        mc_idx = contains(session_name(:,2),mice{i_mice});
        x = diff(decoder_perf_summary(idx & mc_idx,1:2,i_stim),1,2);
        plot(i_mice*ones(length(x),1),x,'Color',x_color(i_mice,:),'Marker','o','LineWidth',2)

    end
    ylim([-0.8 0.2])
    xticks(1:length(mice))
    xticklabels(mice)
    ylabel('\Delta decoder performance (stim-ctrl)')
    title(strcat('train on ctrl-',stim_types{i_stim}),'Interpreter','none')

    subplot(2,2,2*i_stim);hold on;
    idx = decoder_perf_summary(:,1,i_stim)>0.7& repeat_num(:,i_stim)>=8;
    % idx = ismember(session_name(:,2),good_sessions);
    for i_mice = 1 : length(mice)
        mc_idx = contains(session_name(:,2),mice{i_mice});
        x = diff(decoder_perf_summary(idx & mc_idx,3:4,i_stim),1,2);
        plot(i_mice*ones(length(x),1),x,'Color',x_color(i_mice,:),'Marker','o','LineWidth',2)

    end
    ylim([-0.8 0.2])
    xticks(1:length(mice))
    xticklabels(mice)
    ylabel('\Delta decoder performance (ctrl-stim)')
    title(strcat('train on stim-',stim_types{i_stim}),'Interpreter','none')
end

%% user defined function
function screen_idx = func_screen_TH_neurons(unit_info_all,sel_nuclei,obj)

TH_recording = strcmp({unit_info_all.target_region}','thalamus');
unit_with_location = ~strcmp({unit_info_all.brain_region_ibl}','TBD');

% get rid of units that without location info or not thalamus recording
remain_idx = find(unit_with_location & TH_recording);
sel_unit_info = unit_info_all(remain_idx);

if ~isempty(sel_unit_info)
    if strcmp(sel_nuclei,'ALL') % entire thalamus dataset
        sel_idx = [1: size(sel_unit_info,1)]';
    elseif strcmp(sel_nuclei,'FN_projecting_TH')
        sel_idx = find(func_find_in_polyhedron(obj.FN_projecting_TH.f,obj.FN_projecting_TH.v*10,sel_unit_info));
    elseif  strcmp(sel_nuclei,'DN_projecting_TH')
        sel_idx = find(func_find_in_polyhedron(obj.DN_projecting_TH.f,obj.DN_projecting_TH.v*10,sel_unit_info));
    elseif strcmp(sel_nuclei,'CB_projecting_TH')
        FN_screen_idx = func_find_in_polyhedron(obj.FN_projecting_TH.f,obj.FN_projecting_TH.v*10,sel_unit_info);
        DN_screen_idx = func_find_in_polyhedron(obj.DN_projecting_TH.f,obj.DN_projecting_TH.v*10,sel_unit_info);
        sel_idx = find(FN_screen_idx | DN_screen_idx);
    elseif strcmp(sel_nuclei,'ALM_projecting_TH')
        x= [sel_unit_info.CCF_z]';
        y= [sel_unit_info.CCF_y]';
        z= [sel_unit_info.CCF_x]';
        sel_idx = find(inpolyhedron(obj.proj_density_obj.f,obj.proj_density_obj.v*25,[x,y,z]));

        % sel_idx = find(func_find_in_polyhedron(obj.ALM_projecting_TH.f,obj.ALM_projecting_TH.v*10,sel_unit_info));
    elseif strcmp(sel_nuclei,'entire_TH')
        x= [sel_unit_info.CCF_z]';
        y= [sel_unit_info.CCF_y]';
        z= [sel_unit_info.CCF_x]';
        sel_idx = find(inpolyhedron(obj.f,obj.v,[x,y,z]));

    else % only selected nucleus
        sel_idx = [];
        for i_unit = 1 : size(sel_unit_info,1)
            if ismember(sel_unit_info(i_unit).brain_region_ibl,sel_nuclei)
                sel_idx = [sel_idx; i_unit];
            end
        end
    end
    tmp = remain_idx(sel_idx);

    screen_idx = false(size(unit_info_all,1),1);
    screen_idx(tmp) = 1;
else
    screen_idx = false(size(unit_info_all,1),1);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sel_idx = func_find_in_polyhedron(tmp_obj_f,tmp_obj_v,unit_info)
% note: this function only works for obj generated using coronal planes
% along AP axis. This is because inpolyhedron function's limitation
% unit_info.x is LR
% unit_info.y is DV
% unit_info.z is AP
tmp_obj_v = tmp_obj_v(:,[3 2 1]);
unit_xyz = [[unit_info.CCF_x]' [unit_info.CCF_y]' [unit_info.CCF_z]'];
sel_idx = inpolyhedron(tmp_obj_f,tmp_obj_v,unit_xyz);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function activity_matrix = func_compute_activity_matrix(spk_times_tmp,population_stable_trials_tmp)
% compute activity matrix (trials are the data points)

T_bin = 0.2;
time_bins = -3.5:.01:1;
n_total_timebins = length(time_bins);
[n_total_trials, n_total_neurons] = size(spk_times_tmp);

activity_matrix = NaN(n_total_neurons,n_total_timebins,n_total_trials);  % [N x time bin x trial]

for i_trial = 1:n_total_trials

    if population_stable_trials_tmp(i_trial)

        for i_neuron = 1:n_total_neurons

            spk_times_iCell = spk_times_tmp{i_trial,i_neuron};

            for i_timebin = 1:n_total_timebins
                n_timebin = time_bins(i_timebin);

                spk_rate_iBin = sum(spk_times_iCell>n_timebin & spk_times_iCell<(n_timebin+T_bin))/T_bin; % cue aligned

                activity_matrix(i_neuron,i_timebin,i_trial) = spk_rate_iBin;
            end
        end

    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function orthonormal_basis = func_compute_orthonormal_basis(activity_matrix,i_yes_trial_training,i_no_trial_training,i_yes_CorrectTrials_training,i_no_CorrectTrials_training,i_yes_ErrorTrials_training,i_no_ErrorTrials_training)
% CD weights  [N x time bin]

time_bins = -3.5:.01:1;

w_LDA_correct = [];


% train CDs
for i_timebin = 1:size(activity_matrix,2)

    %training data
    data_train_yes  = squeeze(activity_matrix(:,i_timebin,i_yes_CorrectTrials_training))';
    data_train_no  = squeeze(activity_matrix(:,i_timebin,i_no_CorrectTrials_training))';

    % data_train_yes_correct  = squeeze(activity_matrix(:,i_timebin,i_yes_CorrectTrials_training))';
    % data_train_no_correct  = squeeze(activity_matrix(:,i_timebin,i_no_CorrectTrials_training))';
    %
    % data_train_yes_error  = squeeze(activity_matrix(:,i_timebin,i_yes_ErrorTrials_training))';
    % data_train_no_error  = squeeze(activity_matrix(:,i_timebin,i_no_ErrorTrials_training))';
    %
    % data_train_yes = (mean(data_train_yes_correct,1) + mean(data_train_no_error,1))/2;
    % data_train_no = (mean(data_train_no_correct,1) + mean(data_train_yes_error,1))/2;

    % data_train_yes = squeeze(activity_matrix(:,i_timebin,[i_yes_CorrectTrials_training;i_no_ErrorTrials_training]))';
    % data_train_no = squeeze(activity_matrix(:,i_timebin,[i_no_CorrectTrials_training;i_yes_ErrorTrials_training]))';

    % KD LDA
    w_iTimeBin = KD_LDA2(data_train_yes,data_train_no);     % N x 1, CD at one time bin
    w_iTimeBin = w_iTimeBin(:,1);
    w_LDA_correct(:,i_timebin) = w_iTimeBin;

end

% take the CD at the end of delay
i_timebin = find(time_bins>-.4 & time_bins<=-.2);     %only use the LDA before cue
w_LDA_mean = mean(w_LDA_correct(:,i_timebin)')';   %average by mean


% Ramping weights
data_train_yes  = mean(activity_matrix(:,:,i_yes_trial_training),3);
data_train_no  = mean(activity_matrix(:,:,i_no_trial_training),3);

t_sample = -2.6; t_delay = -1.3; t_response = 0;
wt = (data_train_yes + data_train_no)/2;

i_t1 = find(time_bins<(t_sample-.2));
i_t2 = find(time_bins<(t_response-.2));
Ramping_mode = mean(wt(:,i_t2(end)),2)-mean(wt(:,i_t1(end)),2);

orthonormal_basis12 = Gram_Schmidt_process([w_LDA_mean Ramping_mode]);

% % SVDs
% n_dim = size(w_LDA_mean,1);
%
% R = mean(activity_matrix(:,i_timebin,i_yes_CorrectTrials_training),3);
% L = mean(activity_matrix(:,i_timebin,i_no_CorrectTrials_training),3);
% activityRL = [R L];
%
% [u s v] = svd(activityRL');


i_timebin = find(time_bins>-2.6 & time_bins<= -.2);
R = mean(activity_matrix(:,i_timebin,i_yes_CorrectTrials_training),3);
L = mean(activity_matrix(:,i_timebin,i_no_CorrectTrials_training),3);
activityRL = [R L];
activityRL_centered = activityRL - mean(activityRL, 2);   % remove mean
N = null(orthonormal_basis12.');   % neurons x (neurons - 2)
activityRL_sub = N.' * activityRL_centered;
[~, S_perp, V_sub] = svd(activityRL_sub.','econ');      % (samples x neurons) SVD
residual_modes = N * V_sub;

orthonormal_basis = [orthonormal_basis12, residual_modes];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_yes_training,i_no_training,i_yes_test,i_no_test] = func_get_trials_btstrp_trl(i_yes_trial,i_no_trial)

% i_yes_trial and i_no_trial has to be bootstrapped, and number of trials
% should match

n_test_trials_tmp1 = [
    length(i_yes_trial)/2,...
    length(i_no_trial)/2,...
    ];

% use half of number of stim trials for training
n_test_trials_tmp = round(min(n_test_trials_tmp1));

n_trials_tmp = length(i_yes_trial);
i_yes_trial = i_yes_trial(randsample(n_trials_tmp,n_trials_tmp)); % scramble trials
i_yes_training = i_yes_trial(1:n_test_trials_tmp);
i_yes_test = i_yes_trial(n_test_trials_tmp+1:end);

n_trials_tmp = length(i_no_trial);
i_no_trial = i_no_trial(randsample(n_trials_tmp,n_trials_tmp)); % scramble trials
i_no_training = i_no_trial(1:n_test_trials_tmp);
i_no_test = i_no_trial(n_test_trials_tmp+1:end);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LDA, end_point] = func_compute_traj_EP(activity_matrix,orthornormal_basis,i_trial_tmp,mode)

LDA = [];
for i_trial = i_trial_tmp'
    LDA = cat(1, LDA, (activity_matrix(:,:,i_trial)'*orthornormal_basis(:,mode))');
end

time_bins = -3.5:.01:1;
i_t = find(time_bins<=-0.2);

if ~isempty(LDA)
    end_point = LDA(:,i_t(end));
else
    end_point = [];
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function histo_curve = func_compute_histo_curve(x_rng,y_value)
Y_all = [];
stp = mode(diff(x_rng));
for i_bin = x_rng
    % i_trials = find(y_value>(i_bin-stp/2) & y_value<=(i_bin+stp/2));
    i_trials = y_value>(i_bin-stp/2) & y_value<=(i_bin+stp/2);
    Y_all(end+1,:) = sum(i_trials);
end
histo_curve = Y_all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function histo_curve = func_group_EP(x_rng,cur_EP)
for ii = 1 : size(cur_EP,2)
    histo_curve(:,ii) = func_compute_histo_curve(x_rng,cur_EP{ii});
end

histo_curve = histo_curve ./ sum(histo_curve,'all');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function var_allDim = func_compute_var(activityRL_train,activityRL_test,w_LDA,time_window)
time_bins = [round(-3.5:0.01:1,2),round(-3.5:0.01:1,2)];

t_st = time_window(1);
t_nd = time_window(2)-0.2;

proj = (activityRL_test(:,time_bins>=t_st & time_bins<=t_nd) - mean(activityRL_train(:,time_bins>=t_st & time_bins<=t_nd),2))'... 
        * w_LDA;

var_allDim = var(proj) ./sum(var(proj));


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ramp_grouped_tmp,RT_group_tmp,norm_ramp_grouped_tmp] = func_group_EP_ramp(traj_ramp,trials,RT,group_num)
    time_bins = round(-3.5:0.01:1,2);

    group_edge = 0:floor(100/group_num):100;

    ramp_grouped_tmp = NaN(group_num,size(time_bins,2),3); % (group,t,all/L/R)
    RT_group_tmp =  NaN(group_num,3); % (group,all/L/R)
    norm_ramp_grouped_tmp = NaN(group_num,size(time_bins,2),3); % (group,t,all/L/R)


    % regardless trial type (L vs R)
    sel_trials = cat(1,trials{5},trials{6},trials{7},trials{8});
    RT_all = RT(sel_trials);
    proj_ramp = cat(1,traj_ramp{1},traj_ramp{2},traj_ramp{3},traj_ramp{4});
    x_edge = prctile(RT_all,group_edge);    
    trials_group = RT_all >= x_edge(1:end-1) & RT_all < x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        ramp_grouped_tmp(i_grp,:,1) = mean(proj_ramp(trials_group(:,i_grp),:),1,'omitmissing');
        RT_group_tmp(i_grp,1) = mean(RT_all(trials_group(:,i_grp),1),1,'omitmissing');
    end

    % trial type seperated (L vs R)
    sel_trials = cat(1,trials{6},trials{7});
    RT_l = RT(sel_trials);
    proj_ramp_l = cat(1,traj_ramp{2},traj_ramp{3});
    x_l_edge = prctile(RT_l,group_edge);
    trials_l_group = RT_l >= x_l_edge(1:end-1) & RT_l < x_l_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_l_group,2)
        ramp_grouped_tmp(i_grp,:,2) = mean(proj_ramp_l(trials_l_group(:,i_grp),:),1,'omitmissing');
        RT_group_tmp(i_grp,2) = mean(RT_l(trials_l_group(:,i_grp),1),1,'omitmissing');
    end

    sel_trials = cat(1,trials{5},trials{8});
    RT_r = RT(sel_trials);
    proj_ramp_r = cat(1,traj_ramp{1},traj_ramp{4});
    x_r_edge = prctile(RT_r,group_edge);
    trials_r_group = RT_r >= x_r_edge(1:end-1) & RT_r < x_r_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_r_group,2)
        ramp_grouped_tmp(i_grp,:,3) = mean(proj_ramp_r(trials_r_group(:,i_grp),:),1,'omitmissing');
        RT_group_tmp(i_grp,3) = mean(RT_r(trials_r_group(:,i_grp),1),1,'omitmissing');
    end
    
    % offset ramp_grouped_tmp based on the baseline firing rate average
    i_t = find(time_bins<-(1.3+1.3+0.2),1,'last'); % each time bin is 0.2s 
    % i_t is the last time point before sample onset
    ramp_grouped_tmp = ramp_grouped_tmp - mean(ramp_grouped_tmp(:,i_t,:));

    ramp_amplitude = squeeze(mean(ramp_grouped_tmp(:,time_bins==-0.2,:),1))';

    norm_ramp_grouped_tmp(:,:,1) = ramp_grouped_tmp(:,:,1) ./ ramp_amplitude(1);% all trial type
    norm_ramp_grouped_tmp(:,:,2) = ramp_grouped_tmp(:,:,2) ./ ramp_amplitude(2);% left trial
    norm_ramp_grouped_tmp(:,:,3) = ramp_grouped_tmp(:,:,3) ./ ramp_amplitude(3);% right trial

    norm_ramp_grouped_tmp = norm_ramp_grouped_tmp(:,time_bins<=-0.2,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,Y_all] =func_compute_decoding_curve(EP_group)

% EP_group = squeeze(EP_group);
num_session = size(EP_group,1);

EP_all = [];
behav_all =[];
for i_sess = 1 : num_session
    tmp = [EP_group{i_sess,1};EP_group{i_sess,2};EP_group{i_sess,3};EP_group{i_sess,4}];
    tmp2 = ones(length(tmp),1)*i_sess; % session id
    EP_all = [EP_all;[tmp,tmp2]];

    behav_tmp = [ones(size(EP_group{i_sess,1}));zeros(size(EP_group{i_sess,2}));zeros(size(EP_group{i_sess,3}));ones(size(EP_group{i_sess,4}))];
    behav_all = [behav_all;behav_tmp];
end



X_all = [];
Y_all = [];
for i_bin = -2:.2:2
    i_trials = find(EP_all(:,1)>(i_bin-.1) & EP_all(:,1)<=(i_bin+.1));
    Y_mean = mean(behav_all(i_trials,1));

    Y_iBtstrp = [];
    for i_btstrp = 1:100
        i_session_btstrp = randsample(unique(EP_all(:,2)), length(unique(EP_all(:,2))), 'true');
        EP_ctrl_iBtstrp = [];
        behavior_ctrl_iBtstrp = [];
        for i_session_tmp = i_session_btstrp'
            EP_ctrl_iBtstrp = [EP_ctrl_iBtstrp; EP_all(EP_all(:,2)==i_session_tmp,1)];
            behavior_ctrl_iBtstrp = [behavior_ctrl_iBtstrp; behav_all(EP_all(:,2)==i_session_tmp,1)];
        end
        i_trials = find(EP_ctrl_iBtstrp>(i_bin-.1) & EP_ctrl_iBtstrp<=(i_bin+.1));
        Y_iBtstrp(end+1,1) = mean(behavior_ctrl_iBtstrp(i_trials));
    end
    Y_std = std(Y_iBtstrp);
    Y_all(end+1,:) = [Y_mean Y_std];
    X_all(end+1,1) = i_bin;
end

Y_all(isnan(Y_all)) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  EP_CD_lick_curve = func_compute_EP_CD_vs_lick(EP_CD,trials)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}

x_value = cat(1,EP_CD{1},EP_CD{2},EP_CD{3},EP_CD{4});
x_rng = -2:0.2:2;

y_value = [false(length(trials{1,5}),1);true(length(trials{1,6}),1);true(length(trials{1,7}),1);false(length(trials{1,8}),1)];
EP_CD_lick_curve(:,1) = func_compute_prediction_curve(x_value,y_value,x_rng); % left

y_value = ~y_value;
EP_CD_lick_curve(:,2) = func_compute_prediction_curve(x_value,y_value,x_rng); % right

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_CD_CRate_curve = func_compute_EP_CD_vs_CRate(EP_CD,trials)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}

x_value = cat(1,EP_CD{1},EP_CD{2},EP_CD{3},EP_CD{4});
x_rng = -2:0.2:2;

y_value = [true(length(trials{1,5}),1);true(length(trials{1,6}),1);false(length(trials{1,7}),1);false(length(trials{1,8}),1)];

EP_CD_CRate_curve = func_compute_prediction_curve(x_value,y_value,x_rng);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_CD_RT_curve = func_compute_EP_CD_vs_RT(EP_CD,trials,RT)
EP_CD_RT_curve = [];

% off set RT accordingly
R_correct_train = mean(RT(trials{1,3}),'omitmissing');
L_correct_train = mean(RT(trials{1,4}),'omitmissing');
offset_RT{1} = RT(trials{1,5})-R_correct_train;
offset_RT{2} = RT(trials{1,6})-L_correct_train;
offset_RT{3} = RT(trials{1,7})-L_correct_train;
offset_RT{4} = RT(trials{1,8})-R_correct_train;

% all trials together
x_value = cat(1,EP_CD{1},EP_CD{2},EP_CD{3},EP_CD{4});
y_value = cat(1,offset_RT{1},offset_RT{2},offset_RT{3},offset_RT{4});
x_rng = -2:0.2:2;

EP_CD_RT_curve(1,:,1) = func_compute_prediction_curve(x_value,y_value,x_rng);

% lick left trials only
x_value = cat(1,EP_CD{2},EP_CD{3});
y_value = cat(1,offset_RT{2},offset_RT{3});
x_rng = -2:0.2:2;

EP_CD_RT_curve(1,:,2) = func_compute_prediction_curve(x_value,y_value,x_rng);

% lick right trials only
x_value = cat(1,EP_CD{1},EP_CD{4});
y_value = cat(1,offset_RT{1},offset_RT{4});
x_rng = -2:0.2:2;

EP_CD_RT_curve(1,:,3) = func_compute_prediction_curve(x_value,y_value,x_rng);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_ramp_lick_curve = func_compute_EP_ramp_vs_lick(EP_ramp,trials)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}

x_value = cat(1,EP_ramp{1},EP_ramp{2},EP_ramp{3},EP_ramp{4});
x_rng = -2:0.2:2;

y_value = [false(length(trials{1,5}),1);true(length(trials{1,6}),1);true(length(trials{1,7}),1);false(length(trials{1,8}),1)];
EP_ramp_lick_curve(:,1) = func_compute_prediction_curve(x_value,y_value,x_rng); % left

y_value = ~y_value;
EP_ramp_lick_curve(:,2) = func_compute_prediction_curve(x_value,y_value,x_rng); % right

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_ramp_CRate_curve = func_compute_EP_ramp_vs_CRate(EP_ramp,trials)

x_value = cat(1,EP_ramp{1},EP_ramp{2},EP_ramp{3},EP_ramp{4});
x_rng = -2:0.2:2;

y_value = [true(length(trials{1,5}),1);true(length(trials{1,6}),1);false(length(trials{1,7}),1);false(length(trials{1,8}),1)];

EP_ramp_CRate_curve = func_compute_prediction_curve(x_value,y_value,x_rng);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_ramp_RT_curve = func_compute_EP_ramp_vs_RT(EP_ramp,trials,RT)
EP_ramp_RT_curve = [];
% all trials together
x_value = cat(1,EP_ramp{1},EP_ramp{2},EP_ramp{3},EP_ramp{4});
y_value = RT(cat(1,trials{1,5},trials{1,6},trials{1,7},trials{1,8}));
x_rng = -2:0.2:2;

EP_ramp_RT_curve(1,:,1) = func_compute_prediction_curve(x_value,y_value,x_rng);

% % lick left trials only
% x_value = cat(1,EP_ramp{2},EP_ramp{3});
% y_value = RT(cat(1,trials{1,6},trials{1,7}));
% x_rng = -2:0.2:2;
% 
% EP_ramp_RT_curve(1,:,2) = func_compute_prediction_curve(x_value,y_value,x_rng); % left
% 
% % lick right trials only
% x_value = cat(1,EP_ramp{1},EP_ramp{4});
% y_value = RT(cat(1,trials{1,5},trials{1,8}));
% x_rng = -2:0.2:2;
% 
% EP_ramp_RT_curve(1,:,3) = func_compute_prediction_curve(x_value,y_value,x_rng); % right

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EP_ramp_EP_CD_group, EP_ramp_group_EP_CD]= func_compute_EP_ramp_vs_EP_CD_grouped(EP_CD,EP_ramp)

EP_ramp_EP_CD_group = [];

x_value1 = cat(1,EP_ramp{2},EP_ramp{3});
y_value1 = cat(1,EP_CD{2},EP_CD{3});

x_value2 = cat(1,EP_ramp{1},EP_ramp{4});
y_value2 = cat(1,EP_CD{1},EP_CD{4});

x_rng = -2:0.5:2;

[EP_ramp_EP_CD_group(:,1),EP_ramp_group_EP_CD(:,1)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,2),EP_ramp_group_EP_CD(:,2)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

% hit trial only
x_value1 = cat(1,EP_ramp{2});
y_value1 = cat(1,EP_CD{2});

x_value2 = cat(1,EP_ramp{1});
y_value2 = cat(1,EP_CD{1});

x_rng = -2:0.5:2;

[EP_ramp_EP_CD_group(:,3),EP_ramp_group_EP_CD(:,3)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,4),EP_ramp_group_EP_CD(:,4)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

% miss trial only
x_value1 = cat(1,EP_ramp{4});
y_value1 = cat(1,EP_CD{4});

x_value2 = cat(1,EP_ramp{3});
y_value2 = cat(1,EP_CD{3});

x_rng = -2:0.5:2;

[EP_ramp_EP_CD_group(:,5),EP_ramp_group_EP_CD(:,5)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,6),EP_ramp_group_EP_CD(:,6)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [prediction_curve,x_value]= func_compute_prediction_curve(x_value,y_value,x_rng)
if isempty(x_value)|| isempty(y_value)
    prediction_curve = NaN(length(x_rng),1);
    x_value = NaN(length(x_rng),1);
    return
end

Y_all = [];
X_all = [];
stp = mode(diff(x_rng));
for i_bin = x_rng
    i_trials = find(x_value(:,1)>(i_bin-stp/2) & x_value(:,1)<=(i_bin+stp/2));
    if length(i_trials)>=0
        Y_mean = mean(y_value(i_trials,1));
        X_mean = mean(x_value(i_trials,1));
    else
        Y_mean = NaN;
        X_mean = NaN;
    end
    Y_all(end+1,:) = [Y_mean];
    X_all(end+1,:) = [X_mean];
end
prediction_curve = Y_all;
x_value = X_all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalize ramp based on baseline and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% amplitudue
function [ramp_grouped_tmp,RT_group_tmp,norm_ramp_grouped_tmp] = func_group_EP_ramp_new(traj_ramp,trials,RT,group_num)
% group reaction time according to ramping activity 

    time_bins = round(-3.5:0.01:1,2);

    group_edge = 0:floor(100/group_num):100;

    ramp_grouped_tmp = NaN(group_num,size(time_bins,2),3); % (group,t,all/L/R)
    RT_group_tmp =  NaN(group_num,3); % (group,all/L/R)
    norm_ramp_grouped_tmp = NaN(group_num,size(time_bins,2),3); % (group,t,all/L/R)


    % offset ramp_grouped_tmp based on the baseline firing rate average
    i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
    i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue
    
    proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
    proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
    proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
    baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
    amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

    % regardless trial type (L vs R)
    proj_ramp_test = [traj_ramp{1}(ismember(trials{1},trials{5}),:);
                      traj_ramp{2}(ismember(trials{2},trials{6}),:);
                      traj_ramp{1}(ismember(trials{1},trials{7}),:);
                      traj_ramp{2}(ismember(trials{2},trials{8}),:);
                      ];
    proj_ramp = (proj_ramp_test - baseline)/amplitude;
    proj_ramp_ep = proj_ramp(:,i_t2);

    sel_trials = cat(1,sort(trials{5}),sort(trials{6}),sort(trials{7}),sort(trials{8}));
    
    RT_all = RT(sel_trials);

    x_edge = prctile(proj_ramp_ep(:,1),group_edge);    
    trials_group = proj_ramp_ep >= x_edge(1:end-1) & proj_ramp_ep < x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        RT_group_tmp(i_grp,1) = mean(RT_all(trials_group(:,i_grp),:),1,'omitmissing');
        ramp_grouped_tmp(i_grp,:,1) = mean(proj_ramp(trials_group(:,i_grp),:),1,'omitmissing');
    end

    % trial type seperated (L vs R)
    % L
    proj_ramp_test = [
                      traj_ramp{2}(ismember(trials{2},trials{6}),:);
                      traj_ramp{1}(ismember(trials{1},trials{7}),:);
                      ];
    proj_ramp = (proj_ramp_test - baseline)/amplitude;
    proj_ramp_ep = proj_ramp(:,i_t2);

    sel_trials = cat(1,sort(trials{6}),sort(trials{7}));
    
    RT_all = RT(sel_trials);

    x_edge = prctile(proj_ramp_ep(:,1),group_edge);    
    trials_group = proj_ramp_ep >= x_edge(1:end-1) & proj_ramp_ep < x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        RT_group_tmp(i_grp,2) = mean(RT_all(trials_group(:,i_grp),:),1,'omitmissing');
        ramp_grouped_tmp(i_grp,:,2) = mean(proj_ramp(trials_group(:,i_grp),:),1,'omitmissing');
    end
    % R
    proj_ramp_test = [
                      traj_ramp{1}(ismember(trials{1},trials{5}),:);
                      traj_ramp{2}(ismember(trials{2},trials{8}),:);
                      ];
    proj_ramp = (proj_ramp_test - baseline)/amplitude;
    proj_ramp_ep = proj_ramp(:,i_t2);

    sel_trials = cat(1,sort(trials{5}),sort(trials{8}));
    
    RT_all = RT(sel_trials);

    x_edge = prctile(proj_ramp_ep(:,1),group_edge);    
    trials_group = proj_ramp_ep >= x_edge(1:end-1) & proj_ramp_ep < x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        RT_group_tmp(i_grp,3) = mean(RT_all(trials_group(:,i_grp),:),1,'omitmissing');
        ramp_grouped_tmp(i_grp,:,3) = mean(proj_ramp(trials_group(:,i_grp),:),1,'omitmissing');
    end

    ramp_grouped_tmp = ramp_grouped_tmp(:,time_bins<=-0.2,:);
    norm_ramp_grouped_tmp = ramp_grouped_tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  EP_ramp_lick_curve = func_compute_EP_ramp_vs_lick_new(traj_ramp,trials)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}

time_bins = round(-3.5:0.01:1,2);
% offset ramp_grouped_tmp based on the baseline firing rate average
i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue

proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

% regardless trial type (L vs R)
proj_ramp_test = [traj_ramp{1}(ismember(trials{1},trials{5}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{6}),i_t2);
    traj_ramp{1}(ismember(trials{1},trials{7}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{8}),i_t2);
    ];
proj_ramp_ep = (proj_ramp_test - baseline)/amplitude;

x_value = proj_ramp_ep;
x_rng = -0:0.2:3;

y_value = [false(length(trials{1,5}),1);true(length(trials{1,6}),1);true(length(trials{1,7}),1);false(length(trials{1,8}),1)];
EP_ramp_lick_curve(:,1) = func_compute_prediction_curve(x_value,y_value,x_rng); % left

y_value = ~y_value;
EP_ramp_lick_curve(:,2) = func_compute_prediction_curve(x_value,y_value,x_rng); % right

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_ramp_CRate_curve = func_compute_EP_ramp_vs_CRate_new(traj_ramp,trials)
time_bins = round(-3.5:0.01:1,2);
% offset ramp_grouped_tmp based on the baseline firing rate average
i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue

proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

% regardless trial type (L vs R)
proj_ramp_test = [traj_ramp{1}(ismember(trials{1},trials{5}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{6}),i_t2);
    traj_ramp{1}(ismember(trials{1},trials{7}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{8}),i_t2);
    ];
proj_ramp_ep = (proj_ramp_test - baseline)/amplitude;

x_value = proj_ramp_ep;
x_rng = -0:0.2:3;

y_value = [true(length(trials{1,5}),1);true(length(trials{1,6}),1);false(length(trials{1,7}),1);false(length(trials{1,8}),1)];

EP_ramp_CRate_curve = func_compute_prediction_curve(x_value,y_value,x_rng);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EP_ramp_RT_curve = func_compute_EP_ramp_vs_RT_new(traj_ramp,trials,RT)
EP_ramp_RT_curve = [];
time_bins = round(-3.5:0.01:1,2);
% offset ramp_grouped_tmp based on the baseline firing rate average
i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue

proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

% regardless trial type (L vs R)
proj_ramp_test = [traj_ramp{1}(ismember(trials{1},trials{5}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{6}),i_t2);
    traj_ramp{1}(ismember(trials{1},trials{7}),i_t2);
    traj_ramp{2}(ismember(trials{2},trials{8}),i_t2);
    ];
proj_ramp_ep = (proj_ramp_test - baseline)/amplitude;

x_value = proj_ramp_ep;
x_rng = -0:0.2:3;

y_value = RT(cat(1,sort(trials{1,5}),sort(trials{1,6}),sort(trials{1,7}),sort(trials{1,8})));

EP_ramp_RT_curve(1,:,1) = func_compute_prediction_curve(x_value,y_value,x_rng);



end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EP_ramp_EP_CD_group, EP_ramp_group_EP_CD]= func_compute_EP_ramp_vs_EP_CD_grouped_new(EP_CD,traj_ramp,trials)
time_bins = round(-3.5:0.01:1,2);
% offset ramp_grouped_tmp based on the baseline firing rate average
i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue

proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

% regardless trial type (L vs R)
proj_ramp_test = {traj_ramp{1}(ismember(trials{1},trials{5}),i_t2),...
    traj_ramp{2}(ismember(trials{2},trials{6}),i_t2),...
    traj_ramp{1}(ismember(trials{1},trials{7}),i_t2),...
    traj_ramp{2}(ismember(trials{2},trials{8}),i_t2),...
    };
EP_ramp = cellfun(@(x) (x-baseline)/amplitude,proj_ramp_test,'UniformOutput',false);

[~,idx1] = sort(trials{5});
[~,idx2] = sort(trials{6});
[~,idx3] = sort(trials{7});
[~,idx4] = sort(trials{8});

EP_ramp_EP_CD_group = [];

x_value1 = cat(1,EP_ramp{2},EP_ramp{3});
y_value1 = cat(1,EP_CD{2}(idx2),EP_CD{3}(idx3));

x_value2 = cat(1,EP_ramp{1},EP_ramp{4});
y_value2 = cat(1,EP_CD{1}(idx1),EP_CD{4}(idx4));

x_rng = 0:0.25:2;

[EP_ramp_EP_CD_group(:,1),EP_ramp_group_EP_CD(:,1)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,2),EP_ramp_group_EP_CD(:,2)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

% hit trial only
x_value1 = cat(1,EP_ramp{2});
y_value1 = cat(1,EP_CD{2}(idx2));

x_value2 = cat(1,EP_ramp{1});
y_value2 = cat(1,EP_CD{1}(idx1));

x_rng = 0:0.25:2;

[EP_ramp_EP_CD_group(:,3),EP_ramp_group_EP_CD(:,3)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,4),EP_ramp_group_EP_CD(:,4)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

% miss trial only
x_value1 = cat(1,EP_ramp{4});
y_value1 = cat(1,EP_CD{4}(idx4));

x_value2 = cat(1,EP_ramp{3});
y_value2 = cat(1,EP_CD{3}(idx3));

x_rng = 0:0.25:2;

[EP_ramp_EP_CD_group(:,5),EP_ramp_group_EP_CD(:,5)] = func_compute_prediction_curve(x_value1,y_value1,x_rng); % left trials
[EP_ramp_EP_CD_group(:,6),EP_ramp_group_EP_CD(:,6)] = func_compute_prediction_curve(x_value2,y_value2,x_rng); % right trials

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% pool trials together to generate all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figures
function [x_value,prediction_curve,nn]= func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng)
if isempty(x_value)|| isempty(y_value)
    prediction_curve = NaN(length(x_rng),1);
    x_value = NaN(length(x_rng),1);
    return
end

Y_all = [];
X_all = [];
nn = [];
stp = mode(diff(x_rng));
n = 1;
for i_bin = x_rng
    i_trials = find(x_value(:,1)>(i_bin-stp/2) & x_value(:,1)<=(i_bin+stp/2));
    Y_mean = mean(y_value(i_trials,1));
    X_mean = mean(x_value(i_trials,1));

    nn(n) = length(i_trials);
    n = n + 1;

    X_iBtstrp = [];
    Y_iBtstrp = [];
    for i_btstrp = 1:100
        i_session_btstrp = randsample(unique(x_value(:,2)), length(unique(x_value(:,2))), 'true');
        x_iBtstrp = [];
        y_iBtstrp = [];
        for i_session_tmp = i_session_btstrp'
            x_iBtstrp = [x_iBtstrp; x_value(x_value(:,2)==i_session_tmp,1)];
            y_iBtstrp = [y_iBtstrp; y_value(x_value(:,2)==i_session_tmp,1)];
        end
        i_trials_btstrp = x_iBtstrp>(i_bin-stp/2) & x_iBtstrp<=(i_bin+stp/2);
        X_iBtstrp(end+1,1) = mean(x_iBtstrp(i_trials_btstrp),'omitmissing');
        Y_iBtstrp(end+1,1) = mean(y_iBtstrp(i_trials_btstrp),'omitmissing');
    end
    X_std = std(X_iBtstrp,'omitmissing');
    X_all(end+1,:) = [X_mean X_std];

    Y_std = std(Y_iBtstrp,'omitmissing');
    Y_all(end+1,:) = [Y_mean Y_std];


end
prediction_curve = Y_all;
x_value = X_all;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,EP_CD_lick_curve] = func_compute_EP_CD_vs_lick_pooltrials(x_rng,EP_CD_ctrl_allSession,trials_allSession,i_round,min_trl_cut)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}
% %
x_value = [];
y_value = [];

num_session = size(EP_CD_ctrl_allSession,1);

for i_sess = 1 : num_session
    EP_tmp = EP_CD_ctrl_allSession{i_sess,1}(i_round,:);
    trials_tmp = trials_allSession{i_sess,1}(i_round,5:8);
    
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value = cat(1,x_value,x_value_tmp);

    y_value_tmp = [true(length(trials_tmp{1,1}),1);false(length(trials_tmp{1,2}),1);false(length(trials_tmp{1,3}),1);true(length(trials_tmp{1,4}),1)];
    y_value = cat(1,y_value,y_value_tmp);
    
end

[X_all,EP_CD_lick_curve,nn] = func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng);
X_all(nn<min_trl_cut,:) = [];
EP_CD_lick_curve(nn<min_trl_cut,:) = [];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [histo_curve,sstd] = func_compute_EP_CD_histo_curve_pooltrials(x_rng,EP_CD_ctrl_allSession,i_round)
x_rng = round(x_rng,2);
num_session = size(EP_CD_ctrl_allSession,1);

cdt = 4; % yes_c no_c yes_e no_e
xx_together = cell(1,4);
for i_sess = 1 : num_session
    EP_CD = EP_CD_ctrl_allSession{i_sess,1}(i_round,:);
    % ctrl
    Y_all = [];
    for j = 1 : cdt

        x = EP_CD{1,j};

        xx_together{j} = [xx_together{j};x,ones(length(x),1)*i_sess];

    end

end
[histo_curve,sstd] = func_local(x_rng,xx_together);
histo_curve = histo_curve*100;
sstd = sstd*100;

% combine value and sstd
histo_curve = cat(3,histo_curve,sstd);

    function [y,sstd] = func_local(x_rng,histo_counts)

        stp = mode(diff(x_rng));
        n = 1;
        for i_bin = x_rng
            num_trl = sum(cellfun(@(x) length(x),histo_counts));
            for jj = 1 : 4
                i_trials = histo_counts{jj}(:,1)>(i_bin-stp/2) & histo_counts{jj}(:,1)<=(i_bin+stp/2);
                y(n,jj) = sum(i_trials) / num_trl;
            end
            Y_iBtstrp = [];
            histo_counts_pool = cat(1,histo_counts{:});
            for i_btstrp = 1 : 100
                i_session_btstrp = randsample(unique(histo_counts_pool(:,2)), length(unique(histo_counts_pool(:,2))), 'true');
                EP_ctrl_iBtstrp = cell(1,4);
                for i_session_tmp = i_session_btstrp'
                    for jj = 1 : 4
                        EP_ctrl_iBtstrp{jj} = [EP_ctrl_iBtstrp{jj}; histo_counts{jj}(histo_counts{jj}(:,2)==i_session_tmp,1)];               
                    end
                end
                num_trl_btstrp = sum(cellfun(@(x) length(x),EP_ctrl_iBtstrp));
                for jj = 1 : 4
                    i_trials = EP_ctrl_iBtstrp{jj}>(i_bin-stp/2) & EP_ctrl_iBtstrp{jj}<=(i_bin+stp/2);
                    Y_iBtstrp(i_btstrp,jj) = sum(i_trials)/ num_trl_btstrp;
                end
            end
             Y_std = std(Y_iBtstrp,[],1,'omitmissing');

             sstd(n,:) = [Y_std];

            n = n+1;

        end
        y(isnan(y)) = 0;


    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,EP_CD_RT_curve] = func_compute_EP_CD_vs_RT_pooltrials(x_rng,EP_CD_ctrl_allSession,trials_allSession,RT_allSession,i_round,min_trl_cut)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}
% %
x_value = [];
y_value = [];
x_value2 = [];
y_value2 = [];
x_value3 = [];
y_value3 = [];

num_session = size(EP_CD_ctrl_allSession,1);

for i_sess = 1 : num_session
    EP_tmp = EP_CD_ctrl_allSession{i_sess,1}(i_round,:);
    trials_train = trials_allSession{i_sess,1}(i_round,3:4);
    trials_tmp = trials_allSession{i_sess,1}(i_round,5:8);
    RT_tmp = RT_allSession{i_sess,1};

    % offset RT accordingly
    R_correct_train = mean(RT_tmp(trials_train{1,1}),'omitmissing');
    L_correct_train = mean(RT_tmp(trials_train{1,2}),'omitmissing');
    offset_RT{1} = RT_tmp(trials_tmp{1,1})-R_correct_train;
    offset_RT{2} = RT_tmp(trials_tmp{1,2})-L_correct_train;
    offset_RT{3} = RT_tmp(trials_tmp{1,3})-L_correct_train;
    offset_RT{4} = RT_tmp(trials_tmp{1,4})-R_correct_train;

    % all trials together
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value = cat(1,x_value,x_value_tmp);

    y_value_tmp = cat(1,offset_RT{1},offset_RT{2},offset_RT{3},offset_RT{4});
    y_value = cat(1,y_value,y_value_tmp);


    % lick left trials only
    x_value_tmp = cat(1,EP_tmp{2},EP_tmp{3});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value2 = cat(1,x_value2,x_value_tmp);

    y_value_tmp = cat(1,offset_RT{2},offset_RT{3});
    y_value2 = cat(1,y_value2,y_value_tmp);
    
    % lick right trials only
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{4});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value3 = cat(1,x_value3,x_value_tmp);

    y_value_tmp = cat(1,offset_RT{1},offset_RT{4});
    y_value3 = cat(1,y_value3,y_value_tmp);

end

[X_all,EP_CD_RT_curve,nn] = func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng);
X_all(nn<min_trl_cut,:) = NaN;
EP_CD_RT_curve(nn<min_trl_cut,:) = NaN;

[X_all2,EP_CD_RT_curve2,nn] = func_compute_prediction_curve_pooltrial(x_value2,y_value2,x_rng); % left trials
X_all2(nn<min_trl_cut,:) = NaN;
EP_CD_RT_curve2(nn<min_trl_cut,:) = NaN;

[X_all3,EP_CD_RT_curve3,nn] = func_compute_prediction_curve_pooltrial(x_value3,y_value3,x_rng); % right trials
X_all3(nn<min_trl_cut,:) = NaN;
EP_CD_RT_curve3(nn<min_trl_cut,:) = NaN;

X_all = cat(3,X_all,X_all2,X_all3);
EP_CD_RT_curve = cat(3,EP_CD_RT_curve,EP_CD_RT_curve2,EP_CD_RT_curve3);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EP_ramp_ctrl_allSession,trajectory_ramp_ctrl_allSession] = func_normalize_ramp_base_amplitude(trajectory_ramp_alltrl_allSession,trials_allSession,time_bins)
time_bins = round(time_bins,2);
n_session = size(trials_allSession,1);
n_round = size(trajectory_ramp_alltrl_allSession{1,1},1);
for i_sess = 1 : n_session
    for i_nd = 1 : n_round
        traj_ramp = trajectory_ramp_alltrl_allSession{i_sess,1}(i_nd,:);
        trials = trials_allSession{i_sess,1}(i_nd,:);

        % offset ramp_grouped_tmp based on the baseline firing rate average
        i_t1 = find(time_bins>-(1.3+1.3+0.5) & time_bins<=-(1.3+1.3+0.2)); % baseline
        i_t2 = find(time_bins<=-0.2,1,'last'); % last time point before go cue


        % regardless trial type (L vs R)
        trajectory_ramp_ctrl_tmp = cell(1,4);
        EP_ramp_ctrl_tmp = cell(1,4);
        proj_ramp_train_yes = traj_ramp{1}(ismember(trials{1},trials{3}),:);
        proj_ramp_train_no = traj_ramp{2}(ismember(trials{2},trials{4}),:);
        proj_ramp_train = [proj_ramp_train_yes;proj_ramp_train_no];
        baseline = mean(proj_ramp_train(:,i_t1),'all','omitmissing');
        amplitude = mean(proj_ramp_train(:,i_t2),"all",'omitmissing') - baseline;

        trajectory_ramp_ctrl_tmp{1} =  (traj_ramp{1}(ismember(trials{1},trials{5}),:) - baseline)/amplitude;
        trajectory_ramp_ctrl_tmp{2} =  (traj_ramp{2}(ismember(trials{2},trials{6}),:) - baseline)/amplitude;
        trajectory_ramp_ctrl_tmp{3} =  (traj_ramp{1}(ismember(trials{1},trials{7}),:) - baseline)/amplitude;
        trajectory_ramp_ctrl_tmp{4} =  (traj_ramp{2}(ismember(trials{2},trials{8}),:) - baseline)/amplitude;

        EP_ramp_ctrl_tmp{1} = trajectory_ramp_ctrl_tmp{1}(:,i_t2);
        EP_ramp_ctrl_tmp{2} = trajectory_ramp_ctrl_tmp{2}(:,i_t2);
        EP_ramp_ctrl_tmp{3} = trajectory_ramp_ctrl_tmp{3}(:,i_t2);
        EP_ramp_ctrl_tmp{4} = trajectory_ramp_ctrl_tmp{4}(:,i_t2);

        trajectory_ramp_ctrl_allSession{i_sess,1}(i_nd,:) = trajectory_ramp_ctrl_tmp;
        EP_ramp_ctrl_allSession{i_sess,1}(i_nd,:) = EP_ramp_ctrl_tmp;


    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,EP_ramp_lick_curve] = func_compute_EP_ramp_vs_lick_pooltrials(x_rng,EP_ramp_ctrl_allSession,trials_allSession,i_round,min_trl_cut)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}
% %
x_value = [];
y_value = [];

num_session = size(EP_ramp_ctrl_allSession);

for i_sess = 1 : num_session
    EP_tmp = EP_ramp_ctrl_allSession{i_sess,1}(i_round,:);
    trials_tmp = trials_allSession{i_sess,1}(i_round,5:8);
    
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value = cat(1,x_value,x_value_tmp);

    y_value_tmp = [true(length(trials_tmp{1,1}),1);false(length(trials_tmp{1,2}),1);false(length(trials_tmp{1,3}),1);true(length(trials_tmp{1,4}),1)];
    y_value = cat(1,y_value,y_value_tmp);
    
end

[X_all,EP_ramp_lick_curve,nn] = func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng);
X_all(nn<min_trl_cut,:) = [];
EP_ramp_lick_curve(nn<min_trl_cut,:) = [];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,EP_ramp_RT_curve] = func_group_EP_ramp_pooltrials(x_rng,EP_ramp_ctrl_allSession,trials_allSession,RT_allSession,i_round,group_num,min_trl_cut,RT_cutoff)
% note: trials = {i_yes_trial,
% i_no_trial,
% i_yes_correct_ctrl_train,
% i_no_correct_ctrl_train,
% i_yes_correct_ctrl_test,
% i_no_correct_ctrl_test,
% i_yes_error_ctrl_test,
% i_no_error_ctrl_test}
% %
x_value = [];
y_value = [];
x_value2 = [];
y_value2 = [];
x_value3 = [];
y_value3 = [];
num_session = size(EP_ramp_ctrl_allSession,1);

% % method 1: pool trials together, split ramping based on real values, same as CD plots
% for i_sess = 1 : num_session
%     EP_tmp = EP_ramp_ctrl_allSession{i_sess,1}(i_round,:);% trial order is sorted
%     trials_train = trials_allSession{i_sess,1}(i_round,3:4);
%     trials_tmp = trials_allSession{i_sess,1}(i_round,5:8);
%     RT_tmp = RT_allSession{i_sess,1};
% 
%     % offset RT accordingly
%     R_correct_train = mean(RT_tmp(trials_train{1,1}),'omitmissing');
%     L_correct_train = mean(RT_tmp(trials_train{1,2}),'omitmissing');
%     offset_RT{1} = RT_tmp(sort(trials_tmp{1,1}))-R_correct_train;
%     offset_RT{2} = RT_tmp(sort(trials_tmp{1,2}))-L_correct_train;
%     offset_RT{3} = RT_tmp(sort(trials_tmp{1,3}))-L_correct_train;
%     offset_RT{4} = RT_tmp(sort(trials_tmp{1,4}))-R_correct_train;
% 
% 
%     % all trials together
%     x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4}); 
%     x_value_tmp =  [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
%     y_value_tmp = cat(1,offset_RT{1},offset_RT{2},offset_RT{3},offset_RT{4});
% 
%     x_value = cat(1,x_value,x_value_tmp);
%     y_value = cat(1,y_value,y_value_tmp);
% 
%     % lick left trials only
%     x_value_tmp = cat(1,EP_tmp{2},EP_tmp{3});
%     x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
%     x_value2 = cat(1,x_value2,x_value_tmp);
% 
%     y_value_tmp = cat(1,offset_RT{2},offset_RT{3});
%     y_value2 = cat(1,y_value2,y_value_tmp);
% 
%     % lick right trials only
%     x_value_tmp = cat(1,EP_tmp{1},EP_tmp{4});
%     x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
%     x_value3 = cat(1,x_value3,x_value_tmp);
% 
%     y_value_tmp = cat(1,offset_RT{1},offset_RT{4});
%     y_value3 = cat(1,y_value3,y_value_tmp);
% 
% 
% 
%     % x_edge = prctile(x_value_tmp(:,1),group_edge);    
%     % trials_group = x_value_tmp > x_edge(1:end-1) & x_value_tmp <= x_edge(2:end); % return n X group of logical matrix
%     % 
%     % 
%     % for i_grp = 1 : size(trials_group,2)
%     %     RT_group_tmp(i_grp,1) = mean(y_value_tmp(trials_group(:,i_grp),:),1,'omitmissing');
%     %     ramp_grouped_tmp(i_grp,1) = mean(x_value_tmp(trials_group(:,i_grp),:),1,'omitmissing');
%     % end
%     % x_value = cat(1,x_value,ramp_grouped_tmp');
%     % y_value = cat(1,y_value,RT_group_tmp');
% 
% 
% end
% 
% [X_all,EP_ramp_RT_curve,nn] = func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng);
% X_all(nn<min_trl_cut) = NaN;
% EP_ramp_RT_curve(nn<min_trl_cut) = NaN;
% 
% [X_all2,EP_ramp_RT_curve2,nn] = func_compute_prediction_curve_pooltrial(x_value2,y_value2,x_rng);
% X_all2(nn<min_trl_cut) = NaN;
% EP_ramp_RT_curve2(nn<min_trl_cut) = NaN;
% 
% [X_all3,EP_ramp_RT_curve3,nn] = func_compute_prediction_curve_pooltrial(x_value3,y_value3,x_rng);
% X_all3(nn<min_trl_cut) = NaN;
% EP_ramp_RT_curve3(nn<min_trl_cut) = NaN;
% 
% X_all = cat(3,X_all,X_all2,X_all3);
% EP_ramp_RT_curve = cat(3,EP_ramp_RT_curve,EP_ramp_RT_curve2,EP_ramp_RT_curve3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method 2: pool trials together, split ramping based on prctiles, no RT offset
group_edge = 0:floor(100/group_num):100;
if group_edge(end)< 100
    group_edge(end) = 100;
end
num_session = size(EP_ramp_ctrl_allSession,1);

RT_group_tmp = cell(3,group_num);
ramp_grouped_tmp = cell(3,group_num);
for i_sess = 1 : num_session
    EP_tmp = EP_ramp_ctrl_allSession{i_sess,1}(i_round,:);% trial order is sorted
    trials_train = trials_allSession{i_sess,1}(i_round,3:4);
    trials_tmp = trials_allSession{i_sess,1}(i_round,5:8);
    RT_tmp = RT_allSession{i_sess,1};

    
    % all trials together
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4}); 
    x_value_tmp =  [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    y_value_tmp = cat(1,RT_tmp(sort(trials_tmp{1})),...
                        RT_tmp(sort(trials_tmp{2})),... 
                        RT_tmp(sort(trials_tmp{3})),...
                        RT_tmp(sort(trials_tmp{4})));
    x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
    y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

    x_edge = prctile(x_value_tmp(:,1),group_edge);    
    trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix
    
    for i_grp = 1 : size(trials_group,2)
        ramp_grouped_tmp{1,i_grp} = cat(1,ramp_grouped_tmp{1,i_grp},x_value_tmp(trials_group(:,i_grp),:));
        RT_group_tmp{1,i_grp} = cat(1,RT_group_tmp{1,i_grp},y_value_tmp(trials_group(:,i_grp),1));
    end



    % lick left trials only
    x_value_tmp = cat(1,EP_tmp{2},EP_tmp{3});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    y_value_tmp = cat(1,RT_tmp(sort(trials_tmp{2})), RT_tmp(sort(trials_tmp{3})));
    x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
    y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

    x_edge = prctile(x_value_tmp(:,1),group_edge);    
    trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        ramp_grouped_tmp{2,i_grp} = cat(1,ramp_grouped_tmp{2,i_grp},x_value_tmp(trials_group(:,i_grp),:));
        RT_group_tmp{2,i_grp} = cat(1,RT_group_tmp{2,i_grp},y_value_tmp(trials_group(:,i_grp),1));
    end

    % lick right trials only
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{4});
    x_value_tmp = [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    y_value_tmp = cat(1,RT_tmp(sort(trials_tmp{1})), RT_tmp(sort(trials_tmp{4})));
    x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
    y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

    x_edge = prctile(x_value_tmp(:,1),group_edge);    
    trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        ramp_grouped_tmp{3,i_grp} = cat(1,ramp_grouped_tmp{3,i_grp},x_value_tmp(trials_group(:,i_grp),:));
        RT_group_tmp{3,i_grp} = cat(1,RT_group_tmp{3,i_grp},y_value_tmp(trials_group(:,i_grp),1));
    end

    
end

for i = 1 : 3
    for i_grp = 1 : group_num
        x_tmp= ramp_grouped_tmp{i,i_grp};
        y_tmp = RT_group_tmp{i,i_grp};

        X_all(i_grp,1,i) = mean(x_tmp(:,1),'omitmissing');
        EP_ramp_RT_curve(i_grp,1,i) = mean(y_tmp,'omitmissing');

        X_iBtstrp = [];
        Y_iBtstrp = [];
        for i_btstrp = 1:100
            i_session_btstrp = randsample(unique(x_tmp(:,2)), length(unique(x_tmp(:,2))), 'true');
            x_iBtstrp = [];
            y_iBtstrp = [];
            for i_session_tmp = i_session_btstrp'
                x_iBtstrp = [x_iBtstrp; x_tmp(x_tmp(:,2)==i_session_tmp,1)];
                y_iBtstrp = [y_iBtstrp; y_tmp(x_tmp(:,2)==i_session_tmp,1)];
            end

            X_iBtstrp(end+1,1) = mean(x_iBtstrp,'omitmissing');
            Y_iBtstrp(end+1,1) = mean(y_iBtstrp,'omitmissing');
        end
        X_std = std(X_iBtstrp,'omitmissing');
        X_all(i_grp,2,i) = X_std;

        Y_std = std(Y_iBtstrp,'omitmissing');
        EP_ramp_RT_curve(i_grp,2,i) = Y_std;

    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ramp_trace = func_group_traceramp_pooltrials(x_rng,trajectory_ramp_ctrl_allSession,EP_ramp_ctrl_allSession,i_round,group_num)

trajectory = [];
x_value = [];
group_edge = 0:floor(100/group_num):100;

num_session = size(EP_ramp_ctrl_allSession);

for i_sess = 1 : num_session
    traj_tmp = trajectory_ramp_ctrl_allSession{i_sess,1}(i_round,:);% trial order is sorted
    EP_tmp = EP_ramp_ctrl_allSession{i_sess,1}(i_round,:);

    % all trials together
    x_value_tmp = cat(1,EP_tmp{1},EP_tmp{2},EP_tmp{3},EP_tmp{4});
    x_value_tmp =  [x_value_tmp,ones(length(x_value_tmp),1)*i_sess];
    x_value = cat(1,x_value,x_value_tmp);

    trajectory_tmp = cat(1,traj_tmp{1},traj_tmp{2},traj_tmp{3},traj_tmp{4});
    trajectory = cat(1,trajectory,trajectory_tmp);


end
[~,ramp_trace] = func_local(x_value,trajectory,x_rng);


    function [x_value,trajectory_group]= func_local(x_value,trajectory,x_rng)

        Y_all = [];
        X_all = [];
        stp = mode(diff(x_rng));
        for i_bin = x_rng
            i_trials = find(x_value(:,1)>(i_bin-stp/2) & x_value(:,1)<=(i_bin+stp/2));
            Y_mean = mean(trajectory(i_trials,:),1);
            X_mean = mean(x_value(i_trials,1));

            Y_iBtstrp = [];
            for i_btstrp = 1:100
                i_session_btstrp = randsample(unique(x_value(i_trials,2)), length(unique(x_value(i_trials,2))), 'true');
                x_iBtstrp = [];
                y_iBtstrp = [];
                for i_session_tmp = i_session_btstrp'
                    x_iBtstrp = [x_iBtstrp; x_value(x_value(:,2)==i_session_tmp,1)];
                    y_iBtstrp = [y_iBtstrp; trajectory(x_value(:,2)==i_session_tmp,:)];
                end
                i_trials_btstrp = x_iBtstrp>(i_bin-stp/2) & x_iBtstrp<=(i_bin+stp/2);
                Y_iBtstrp(end+1,:) = mean(y_iBtstrp(i_trials_btstrp,:));
            end
            X_std = std(x_iBtstrp,'omitmissing');
            X_all(end+1,:) = [X_mean X_std];

            Y_std = std(Y_iBtstrp,[],1,'omitmissing');
            Y_all(end+1,:,:) = cat(3,Y_mean,Y_std);

        end
        trajectory_group = Y_all;
        x_value = X_all;

    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ramp_trace = func_group_tracramp_pooltrials_baseRT(trajectory_ramp_ctrl_allSession,RT_allSession,trials_allSession,i_round,group_num,RT_cutoff)
trajectory = [];
x_value = [];
group_edge = 0:floor(100/group_num):100;
% if group_edge(end)< 100
%     group_edge(end) = 100;
% end

% %%% method 1 : pool trials, average across trials, bootstrap session
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num_session = size(trajectory_ramp_ctrl_allSession);
% ramp_trace_tmp = cell(1,group_num);
% session_idx = cell(1,group_num);
% for i_sess = 1 : num_session
%     traj_tmp = trajectory_ramp_ctrl_allSession{i_sess,1}(i_round,:);% trial order is sorted
%     RT_tmp = RT_allSession{i_sess,1};
%     trials = trials_allSession{i_sess,1}(i_round,5:8);
% 
% 
%     sel_trials = cat(1,sort(trials{1}),sort(trials{2}),sort(trials{3}),sort(trials{4}));   
%     RT_all = RT_tmp(sel_trials);
%     traj_all = cat(1,traj_tmp{1},traj_tmp{2},traj_tmp{3},traj_tmp{4});
% 
%     traj_all(RT_all>RT_cutoff,:) = [];
%     RT_all(RT_all>RT_cutoff,:) = [];
% 
%     x_edge = prctile(RT_all(:,1),group_edge);    
%     trials_group = RT_all >= x_edge(1:end-1) & RT_all < x_edge(2:end); % return n X group of logical matrix
% 
%     for i_grp = 1 : size(trials_group,2)
%         session_idx{1,i_grp} = cat(1,session_idx{1,i_grp},ones(sum(trials_group(:,i_grp)),1) * i_sess);
%         ramp_trace_tmp{1,i_grp} = cat(1,ramp_trace_tmp{1,i_grp},traj_all(trials_group(:,i_grp),:));
%     end
% 
% end
% 
% for i_grp = 1 : group_num
%     x_tmp= session_idx{1,i_grp};
%     y_tmp = ramp_trace_tmp{1,i_grp};
% 
%     ramp_trace(i_grp,:,1) = mean(y_tmp,1,'omitmissing');
% 
%     Y_iBtstrp = [];
%     for i_btstrp = 1:100
%         i_session_btstrp = randsample(unique(x_tmp(:,1)), length(unique(x_tmp(:,1))), 'true');
%         y_iBtstrp = [];
%         for i_session_tmp = i_session_btstrp'
%             y_iBtstrp = [y_iBtstrp; y_tmp(x_tmp(:,1)==i_session_tmp,:)];
%         end
%         Y_iBtstrp(end+1,:) = mean(y_iBtstrp,1,'omitmissing');
%     end
% 
%     Y_std = std(Y_iBtstrp,1,'omitmissing');
%     ramp_trace(i_grp,:,2) = Y_std;
% 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% method 1 : average across trials to get individual session trace, sme is across sessions
num_session = size(trajectory_ramp_ctrl_allSession);
ramp_trace_tmp = cell(1,group_num);
for i_sess = 1 : num_session
    traj_tmp = trajectory_ramp_ctrl_allSession{i_sess,1}(i_round,:);% trial order is sorted
    RT_tmp = RT_allSession{i_sess,1};
    trials = trials_allSession{i_sess,1}(i_round,5:8);
    
    
    sel_trials = cat(1,sort(trials{1}),sort(trials{2}),sort(trials{3}),sort(trials{4}));   
    RT_all = RT_tmp(sel_trials);
    traj_all = cat(1,traj_tmp{1},traj_tmp{2},traj_tmp{3},traj_tmp{4});

    traj_all(RT_all>RT_cutoff,:) = [];
    RT_all(RT_all>RT_cutoff,:) = [];

    x_edge = prctile(RT_all(:,1),group_edge);    
    trials_group = RT_all >= x_edge(1:end-1) & RT_all < x_edge(2:end); % return n X group of logical matrix

    for i_grp = 1 : size(trials_group,2)
        ramp_trace_tmp{1,i_grp} = cat(1,ramp_trace_tmp{1,i_grp},mean(traj_all(trials_group(:,i_grp),:),1,'omitmissing'));
    end

end

for i_grp = 1 : group_num
    y_tmp = ramp_trace_tmp{1,i_grp};

    ramp_trace(i_grp,:,1) = mean(y_tmp,1,'omitmissing');

    ramp_trace(i_grp,:,2) = std(y_tmp,1,'omitmissing')./ sqrt(size(y_tmp,1));

end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EP_ramp_group1,EP_cd_group1,EP_ramp_group2,EP_cd_group2]= func_compute_EP_ramp_vs_EP_CD_pooltrials(x_rng,EP_CD_allsession,EP_ramp_allsession,trials_allsession,i_round,min_trl_cut)
n_session = size(EP_CD_allsession,1);

idx1_session = [];
x_value1 = [];
y_value1 = [];

idx2_session = [];
x_value2 = [];
y_value2 = [];

for i_sess = 1 : n_session
    EP_CD = EP_CD_allsession{i_sess,1}(i_round,:);
    EP_ramp = EP_ramp_allsession{i_sess,1}(i_round,:);
    trials = trials_allsession{i_sess,1}(i_round,:);

    [~,idx1] = sort(trials{5});
    [~,idx2] = sort(trials{6});
    [~,idx3] = sort(trials{7});
    [~,idx4] = sort(trials{8});


    x_value_tmp1 = cat(1,EP_ramp{2},EP_ramp{3});
    y_value_tmp1 = cat(1,EP_CD{2}(idx2),EP_CD{3}(idx3));

    x_value_tmp2 = cat(1,EP_ramp{1},EP_ramp{4});
    y_value_tmp2 = cat(1,EP_CD{1}(idx1),EP_CD{4}(idx4));

    % % hit trial only
    % x_value_tmp1 = cat(1,EP_ramp{2});
    % y_value_tmp1 = cat(1,EP_CD{2}(idx2));
    % 
    % x_value_tmp2 = cat(1,EP_ramp{1});
    % y_value_tmp2 = cat(1,EP_CD{1}(idx1));
    %
    %
    % % miss trial only
    % x_value_tmp1 = cat(1,EP_ramp{4});
    % y_value_tmp1 = cat(1,EP_CD{4}(idx4));
    %
    % x_value_tmp2 = cat(1,EP_ramp{3});
    % y_value_tmp2 = cat(1,EP_CD{3}(idx3));

    idx1_session = cat(1,idx1_session,ones(length(x_value_tmp1),1)*i_sess);
    x_value1 = cat(1,x_value1,x_value_tmp1);
    y_value1 = cat(1,y_value1,y_value_tmp1);

    idx2_session = cat(1,idx2_session,ones(length(x_value_tmp2),1)*i_sess);
    x_value2 = cat(1,x_value2,x_value_tmp2);
    y_value2 = cat(1,y_value2,y_value_tmp2);

end

      

Y1_all = [];
X1_all = [];
Y2_all = [];
X2_all = [];
stp = mode(diff(x_rng));
for i_bin = x_rng
    i_trials = find(x_value1(:,1)>(i_bin-stp/2) & x_value1(:,1)<=(i_bin+stp/2));
    if length(i_trials)>= min_trl_cut
        Y1_mean = mean(y_value1(i_trials,1));
        X1_mean = mean(x_value1(i_trials,1));
    else
        Y1_mean = NaN;
        X1_mean = NaN;
    end
    i_trials = find(x_value2(:,1)>(i_bin-stp/2) & x_value2(:,1)<=(i_bin+stp/2));    
    if length(i_trials)>= min_trl_cut
        Y2_mean = mean(y_value2(i_trials,1));
        X2_mean = mean(x_value2(i_trials,1));
    else
        Y2_mean = NaN;
        X2_mean = NaN;
    end

    sessions = unique([idx1_session;idx2_session]);
    X1_iBtstrp = [];
    Y1_iBtstrp = [];
    X2_iBtstrp = [];
    Y2_iBtstrp = [];
    for i_btstrp = 1:100
        i_session_btstrp = randsample(sessions, length(sessions), 'true');
        x1_iBtstrp = [];
        y1_iBtstrp = [];
        x2_iBtstrp = [];
        y2_iBtstrp = [];
        for i_session_tmp = i_session_btstrp'
            x1_iBtstrp = [x1_iBtstrp; x_value1(idx1_session==i_session_tmp,1)];
            y1_iBtstrp = [y1_iBtstrp; y_value1(idx1_session==i_session_tmp,1)];

            x2_iBtstrp = [x2_iBtstrp; x_value2(idx2_session==i_session_tmp,1)];
            y2_iBtstrp = [y2_iBtstrp; y_value2(idx2_session==i_session_tmp,1)];
        end
        i_trials_btstrp = x1_iBtstrp>(i_bin-stp/2) & x1_iBtstrp<=(i_bin+stp/2);
        X1_iBtstrp(end+1,:) = mean(x1_iBtstrp(i_trials_btstrp,:));
        Y1_iBtstrp(end+1,:) = mean(y1_iBtstrp(i_trials_btstrp,:));
        i_trials_btstrp = x2_iBtstrp>(i_bin-stp/2) & x2_iBtstrp<=(i_bin+stp/2);
        X2_iBtstrp(end+1,:) = mean(x2_iBtstrp(i_trials_btstrp,:));
        Y2_iBtstrp(end+1,:) = mean(y2_iBtstrp(i_trials_btstrp,:));
    end
    X1_std = std(X1_iBtstrp,'omitmissing');
    X1_all(end+1,:) = [X1_mean X1_std];
    Y1_std = std(Y1_iBtstrp,[],1,'omitmissing');
    Y1_all(end+1,:,:) = [Y1_mean,Y1_std];


    X2_std = std(X2_iBtstrp,'omitmissing');
    X2_all(end+1,:) = [X2_mean X2_std];
    Y2_std = std(Y2_iBtstrp,[],1,'omitmissing');
    Y2_all(end+1,:,:) = [Y2_mean,Y2_std];


end
EP_ramp_group1 = X1_all;
EP_cd_group1 = Y1_all;
EP_ramp_group2 = X2_all;
EP_cd_group2 = Y2_all;




end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RT_video = func_get_video_RT(file_folder,variable_name,behavior_tmp)
aa = split(variable_name,'_');
mouse = aa{1};
% load video RT from video processsed data
try
    load(fullfile(file_folder,mouse,[variable_name,'.mat']))
catch
    RT_video = NaN(length(behavior_tmp.trial_original_index),1);
    disp('no video output')
    return
end

RT_video = NaN(length(behavior_tmp.trial_original_index),1);
for i_trl = 1 : length(RT_video)
    cur_trl = behavior_tmp.trial_original_index(i_trl);
    
    idx = find([data_struct.CorrectTrial]' == cur_trl);

    if ~isempty(idx)
        RT_video(i_trl) = data_struct(idx).video_RT;
    end

end

end













