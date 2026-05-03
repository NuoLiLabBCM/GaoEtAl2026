% This code plots Figs 2c and 2d, extended figs 3d and 3e

load('fig2hi.mat')

%% plot criteria
min_trl_cut = 5;
sel_session = cellfun(@(x) all(x([1 4],1)>0.6,1),decoder_perf_allsession); % for figure 2 


% plot average projection of CD and ramping

% proj_activity_allsession (session,t,mode,cdt,Lhit/Rhit/Lmiss/Rmiss/Llick/Rlick/Linstruct/Rinstruct)
% (trl,t,cd/ramp,early/late)



figure() % within condition, choice
subplot(1,2,1);hold on;
tmp = proj_activity(sel_session,:,1,1,1); % yes,%(sess,t,cd/ramp,early/late,trl_type)            
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,1,1,2); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-1 1],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-1 1])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')

subplot(1,2,2);hold on;
tmp = proj_activity(sel_session,:,1,2,3); % yes
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,1,2,4); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-1 1],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-1 1])
ylabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')


figure() % within condition, ramping
subplot(1,2,1);hold on;
tmp = proj_activity(sel_session,:,2,1,1); % yes,%(sess,t,cd/ramp,early/late,trl_type)            
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,2,1,2); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-.1 1.2],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-.1 1.2])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')

subplot(1,2,2);hold on;
tmp = proj_activity(sel_session,:,2,2,3); % yes
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,2,2,4); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-.1 1.2],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-.1 1.2])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')


figure() % across condition, choice
subplot(1,2,1);hold on;
tmp = mean(proj_activity(sel_session,:,1,1,1),1);
plot(time_bins+T_bin/2,tmp,'b')
tmp = mean(proj_activity(sel_session,:,1,1,2),1);
plot(time_bins+T_bin/2,tmp,'r')
tmp = proj_activity(sel_session,:,1,1,3); % yes,%(sess,t,cd/ramp,early/late,trl_type)            
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,1,1,4); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-1 1],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-1 1])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')

subplot(1,2,2);hold on;
tmp = mean(proj_activity(sel_session,:,1,2,3),1);
plot(time_bins+T_bin/2,tmp,'b')
tmp = mean(proj_activity(sel_session,:,1,2,4),1);
plot(time_bins+T_bin/2,tmp,'r')
tmp = proj_activity(sel_session,:,1,2,1); % yes
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,1,2,2); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3],[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-1 1],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-1 1],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-1 1])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')


figure() % across condition, ramping
subplot(1,2,1);hold on;
tmp = mean(proj_activity(sel_session,:,2,1,1),1);
plot(time_bins+T_bin/2,tmp,'b')
tmp = mean(proj_activity(sel_session,:,2,1,2),1);
plot(time_bins+T_bin/2,tmp,'r')
tmp = proj_activity(sel_session,:,2,1,3); % yes,%(sess,t,cd/ramp,early/late,trl_type)            
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,2,1,4); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-.1 1.2],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-.1 1.2])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')

subplot(1,2,2);hold on;
tmp = mean(proj_activity(sel_session,:,2,2,3),1);
plot(time_bins+T_bin/2,tmp,'b')
tmp = mean(proj_activity(sel_session,:,2,2,4),1);
plot(time_bins+T_bin/2,tmp,'r')
tmp = proj_activity(sel_session,:,2,2,1); % yes
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'b',[.4 .4 .7],'none',1);
tmp = proj_activity(sel_session,:,2,2,2); % no
func_plot_mean_and_sem(time_bins+T_bin/2,tmp,'r',[.7 .4 .4],'none',1);
line([0 0],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3],[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(1),[-.1 1.2],'color','k','LineStyle','-')
line([1.3 1.3]+delay_combo(2),[-.1 1.2],'color','k','LineStyle','-')
ylabel('Activity proj. (a.u.)');ylim([-.1 1.2])
xlabel('Time (s)');xticks([0:4]);xlim([-0.5 4.5])
set(gca,'Box','off','TickDir','out')

%% plot cd decoding curve
x_rng = round(-2:0.25:2,2);
[X_all,EP_lick_curve] = func_compute_EP_vs_lick_pooltrial(x_rng,EP_CD_ctrl_allsession(sel_session,1),trl_info_allsession(sel_session,1),'alm',min_trl_cut);

decoder_perf = cellfun(@(x) x(:,1),decoder_perf_allsession(sel_session,1),'UniformOutput',false);
decoder_perf = cell2mat(decoder_perf')';
[h,p] = ttest(decoder_perf(:,1),decoder_perf(:,4))

figure();
subplot(2,1,1);hold on;

good_bins = ~isnan(X_all(:,1));
xx = X_all(good_bins,1);
yy = EP_lick_curve(good_bins,:,1);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[0.5 0.5 0.5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color','k')

good_bins = ~isnan(X_all(:,2));
xx = X_all(good_bins,2);
yy = EP_lick_curve(good_bins,:,2);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[1 .8 .5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color',[1 .5 0])

xlabel('CD (a.u.)');xlim([-2 2]);xticks([-2:1:2])
ylabel('Fraction of lick right')
title('Activity proj. on early CD')
legend({'';'early trls';'';'late trls'},'Box','off','location','northwest')
set(gca,'TickDir','out')

subplot(2,1,2);hold on;
good_bins = ~isnan(X_all(:,3));
xx = X_all(good_bins,3);
yy = EP_lick_curve(good_bins,:,3);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[0.5 0.5 0.5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color','k')

good_bins = ~isnan(X_all(:,4));
xx = X_all(good_bins,4);
yy = EP_lick_curve(good_bins,:,4);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[1 .8 .5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color',[1 .5 0])

title('Activity proj. on late CD')
xlabel('CD (a.u.)');xlim([-2 2]);xticks([-2:1:2])
ylabel('Fraction of lick right')
set(gca,'TickDir','out')


% overlay within conditions curves
figure();hold on;

good_bins = ~isnan(X_all(:,1));
xx = X_all(good_bins,1);
yy = EP_lick_curve(good_bins,:,1);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[0.5 0.5 0.5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color','k')

good_bins = ~isnan(X_all(:,4));
xx = X_all(good_bins,4);
yy = EP_lick_curve(good_bins,:,4);
patch([xx;flip(xx)],[yy(:,1)+yy(:,2);flip(yy(:,1)-yy(:,2))],[1 .8 .5],'facealpha',0.5,'edgecolor','none')
plot(xx,yy(:,1),'color',[1 .5 0])
xlabel('CD (a.u.)');xlim([-2 2]);xticks([-2:1:2])
ylabel('Fraction of lick right');ylim([0 1]);yticks([0 .5 1])
title('Activity proj. on choice mode (a.u.)')
legend({'';'early trls';'';'late trls'},'Box','off','location','northwest')
set(gca,'TickDir','out')

%% plot ramping grouped according to RT
group_num = 4;
RT_cutoff = 0.5;
% ramping vs RT
[X_all,EP_ramp_RT_curve,mtrx] = func_compute_EP_vs_RT_pooltrials([0:0.4:2],EP_ramp_ctrl_allsession(sel_session,1),trl_info_allsession(sel_session,1),'alm',min_trl_cut,group_num,RT_cutoff);


% two-way ANOVA
test_conditions = mtrx(:,5) == 1 | mtrx(:,5) == 4;
tbl = table( ...
    mtrx(test_conditions,1), ...                    % RT
    mtrx(test_conditions,2), ...                    % ramp
    categorical(mtrx(test_conditions,3)), ...       % session
    categorical(mtrx(test_conditions,4)), ...       % group
    categorical(mtrx(test_conditions,5)), ...       % condition
    'VariableNames', {'RT','ramp','session','group','condition'} );

% Linear mixed-effects model
lme_cont = fitlme(tbl, ...
    'RT ~ condition * ramp + (1 | session)');

anova(lme_cont)

figure();
subplot(2,1,1);hold on;

xx = X_all(:,:,1);
yy = EP_ramp_RT_curve(:,:,1);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'k','linestyle','none')

xx = X_all(:,:,2);
yy = EP_ramp_RT_curve(:,:,2);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'color',[1 .8 .5],'linestyle','none')

xlabel('ramp (a.u.)');xlim([0.4 1.5]);xticks([0.5:0.5:1.5])
ylabel(' Reaction time (s)');ylim([0.09 0.13])
legend({'early trls';'late trls'},'Box','off','location','northwest')
set(gca,'TickDir','out')

subplot(2,1,2);hold on;
xx = X_all(:,:,3);
yy = EP_ramp_RT_curve(:,:,3);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'k','linestyle','none')

xx = X_all(:,:,4);
yy = EP_ramp_RT_curve(:,:,4);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'color',[1 .8 .5],'linestyle','none')

title('Activity proj. on late CD')
xlabel('ramp (a.u.)');xlim([0.4 1.5]);xticks([0.5:0.5:1.5])
ylabel('Reaction time (s)');ylim([0.09 0.13])
set(gca,'TickDir','out')


% overlay within conditions curves
figure();hold on;

xx = X_all(:,:,1);
yy = EP_ramp_RT_curve(:,:,1);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'k','linestyle','none')
xx = X_all(:,:,4);
yy = EP_ramp_RT_curve(:,:,4);
errorbar(xx(:,1),yy(:,1),yy(:,2),yy(:,2),xx(:,2),xx(:,2),'color',[1 .8 .5],'linestyle','none')

xlabel('ramp (a.u.)');xlim([0.4 1.5]);xticks([0.5:0.5:1.5])
ylabel('\Delta reaction time (s)');ylim([0.09 0.13])
legend({'early trls';'late trls'},'Box','off','location','northwest')
set(gca,'TickDir','out')




%% user defined functions


% sub function
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_all,Y_all,decoder_perf] = func_get_decoding(ep_cd,trl_info)
X_all = round(-2:.2:2,1);
Y_all = NaN(2,size(X_all,2)); % (early/late,n_bins)
decoder_perf = NaN(2,1);

% early trials
R_lick_idx = (trl_info.R_hit | trl_info.L_miss) & (trl_info.yes_early_test|trl_info.no_early_test);
L_lick_idx = (trl_info.L_hit | trl_info.R_miss) & (trl_info.yes_early_test|trl_info.no_early_test);

EP_ctrl_all = [ep_cd(R_lick_idx,1);ep_cd(L_lick_idx,1)];
behavior_ctrl_all = [true(sum(R_lick_idx),1); false(sum(L_lick_idx),1)];

for i_bin = 1:size(X_all,2)
    i_trials = find(EP_ctrl_all(:,1)>(X_all(i_bin)-.1) & EP_ctrl_all(:,1)<=(X_all(i_bin)+.1));
    Y_mean = mean(behavior_ctrl_all(i_trials,1));
    
    Y_all(1,i_bin) = [Y_mean];
end
decoder_perf(1) = (sum(EP_ctrl_all(behavior_ctrl_all)>0) + sum(EP_ctrl_all(~behavior_ctrl_all)<0)) / length(EP_ctrl_all);

% late trials
R_lick_idx = (trl_info.R_hit | trl_info.L_miss) & (trl_info.yes_late_test|trl_info.no_late_test);
L_lick_idx = (trl_info.L_hit | trl_info.R_miss) & (trl_info.yes_late_test|trl_info.no_late_test);

EP_ctrl_all = [ep_cd(R_lick_idx,1);ep_cd(L_lick_idx,1)];
behavior_ctrl_all = [true(sum(R_lick_idx),1); false(sum(L_lick_idx),1)];

for i_bin = 1:size(X_all,2)
    i_trials = find(EP_ctrl_all(:,1)>(X_all(i_bin)-.1) & EP_ctrl_all(:,1)<=(X_all(i_bin)+.1));
    Y_mean = mean(behavior_ctrl_all(i_trials,1));
    
    Y_all(2,i_bin) = [Y_mean];
end
decoder_perf(2) = (sum(EP_ctrl_all(behavior_ctrl_all)>0) + sum(EP_ctrl_all(~behavior_ctrl_all)<0)) / length(EP_ctrl_all);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ramp_grouped_tmp,RT_group_tmp,norm_ramp_grouped_tmp,EP_ramp_grouped_tmp] = func_group_EP_ramp(proj_ramp,ramp_amplitude,trials,RT,group_num,time_bins,T_bin)

group_edge = 0:floor(100/group_num):100;

ramp_grouped_tmp = NaN(group_num,size(proj_ramp,2),3); % (group,t,all/L/R)
RT_group_tmp =  NaN(group_num,3); % (group,all/L/R)
norm_ramp_grouped_tmp = NaN(group_num,size(proj_ramp,2),3); % (group,t,all/L/R)

% regardless trial type (L vs R)
RT_tmp = RT(trials{1,1});
proj_ramp_tmp = proj_ramp(trials{1,1},:);
x_edge = prctile(RT_tmp,group_edge);
trials_group = RT_tmp >= x_edge(1:end-1) & RT_tmp < x_edge(2:end); % return n X group of logical matrix

for i_grp = 1 : size(trials_group,2)
    ramp_grouped_tmp(i_grp,:,1) = mean(proj_ramp_tmp(trials_group(:,i_grp),:),1,'omitmissing');
    RT_group_tmp(i_grp,1) = mean(RT_tmp(trials_group(:,i_grp),1),1,'omitmissing');
end

% trial type seperated (L vs R)
RT_l = RT(trials{1,2});
proj_ramp_l = proj_ramp(trials{1,2},:);
x_l_edge = prctile(RT_l,group_edge);
trials_l_group = RT_l >= x_l_edge(1:end-1) & RT_l < x_l_edge(2:end); % return n X group of logical matrix

for i_grp = 1 : size(trials_l_group,2)
    ramp_grouped_tmp(i_grp,:,2) = mean(proj_ramp_l(trials_l_group(:,i_grp),:),1,'omitmissing');
    RT_group_tmp(i_grp,2) = mean(RT_l(trials_l_group(:,i_grp),1),1,'omitmissing');
end

RT_r = RT(trials{1,3});
proj_ramp_r = proj_ramp(trials{1,3},:);
x_r_edge = prctile(RT_r,group_edge);
trials_r_group = RT_r >= x_r_edge(1:end-1) & RT_r < x_r_edge(2:end); % return n X group of logical matrix

for i_grp = 1 : size(trials_r_group,2)
    ramp_grouped_tmp(i_grp,:,3) = mean(proj_ramp_r(trials_r_group(:,i_grp),:),1,'omitmissing');
    RT_group_tmp(i_grp,3) = mean(RT_r(trials_r_group(:,i_grp),1),1,'omitmissing');
end

i_t = find(time_bins<-0-T_bin,1,'last'); % each time bin is 0.2s
ramp_grouped_tmp = ramp_grouped_tmp - mean(ramp_grouped_tmp(:,i_t,:),1);

norm_ramp_grouped_tmp(:,:,1) = ramp_grouped_tmp(:,:,1) ./ ramp_amplitude(1);% all trial type
norm_ramp_grouped_tmp(:,:,2) = ramp_grouped_tmp(:,:,2) ./ ramp_amplitude(2);% left trial
norm_ramp_grouped_tmp(:,:,3) = ramp_grouped_tmp(:,:,3) ./ ramp_amplitude(3);% right trial

% get EP from norm_ramp_grouped_tmp
i_t = find(~isnan(ramp_grouped_tmp(1,:,1)),1,'last');
EP_ramp_grouped_tmp = squeeze(norm_ramp_grouped_tmp(:,i_t,:));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  EP_CD_lick_curve = func_compute_EP_vs_lick(EP_CD,trl_info)
% EP_CD = (trl,proj to early/late) (normalized by std)
EP_CD_lick_curve = [];

x_rng = round(-2:0.2:2,1);
early_trls = trl_info.yes_early_test | trl_info.no_early_test;
late_trls = trl_info.yes_late_test | trl_info.no_late_test;

for i = 1 : 4
    switch i
        case 1 % early trls on early cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,1);
        case 2 % late trls on early cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,1);
        case 3 % ealy trls on late cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,2);
        case 4 % late trls on late cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,2);
    end

y_value =  trl_info.L_hit(sel_trl) | trl_info.R_miss(sel_trl);
EP_CD_lick_curve(:,1,i) = func_compute_prediction_curve(x_value,y_value,x_rng); % left

y_value = trl_info.R_hit(sel_trl) | trl_info.L_miss(sel_trl);
EP_CD_lick_curve(:,2,i) = func_compute_prediction_curve(x_value,y_value,x_rng); % right

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  EP_CD_CRate_curve = func_compute_EP_vs_CRate(EP_CD,trl_info)
% EP_CD = (trl,proj to early/late) (normalized by std)
EP_CD_lick_curve = [];

x_rng = round(-2:0.2:2,1);
early_trls = trl_info.yes_early_test | trl_info.no_early_test;
late_trls = trl_info.yes_late_test | trl_info.no_late_test;

for i = 1 : 4
    switch i
        case 1 % early trls on early cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,1);
        case 2 % late trls on early cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,1);
        case 3 % ealy trls on late cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,2);
        case 4 % late trls on late cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,2);
    end

y_value =  trl_info.L_hit(sel_trl) | trl_info.R_hit(sel_trl);
EP_CD_CRate_curve(:,i) = func_compute_prediction_curve(x_value,y_value,x_rng); 

end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  EP_CD_RT_curve = func_compute_EP_vs_RT(EP_CD,trl_info,RT)
% EP_CD = (trl,proj to early/late) (normalized by std)
EP_CD_RT_curve = [];

x_rng = round(-2:0.2:2,1);
early_trls = trl_info.yes_early_test | trl_info.no_early_test;
late_trls = trl_info.yes_late_test | trl_info.no_late_test;

for i = 1 : 4
    switch i
        case 1 % early trls on early cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,1);
            y_value = RT(sel_trl);
        case 2 % late trls on early cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,1);
            y_value = RT(sel_trl);
        case 3 % ealy trls on late cd
            sel_trl = early_trls;
            x_value = EP_CD(sel_trl,2);
            y_value = RT(sel_trl);
       case 4 % late trls on late cd
            sel_trl = late_trls;
            x_value = EP_CD(sel_trl,2);
            y_value = RT(sel_trl);
    end

    % all lick dir trials
    EP_CD_RT_curve(:,1,i) = func_compute_prediction_curve(x_value,y_value,x_rng);

    % lick left trials only
    x_value2 = x_value(trl_info.L_hit(sel_trl) | trl_info.R_miss(sel_trl));
    y_value2 = y_value(trl_info.L_hit(sel_trl) | trl_info.R_miss(sel_trl));
    EP_CD_RT_curve(:,2,i) = func_compute_prediction_curve(x_value2,y_value2,x_rng);

    % lick right trials only
    x_value3 = x_value(trl_info.R_hit(sel_trl) | trl_info.L_miss(sel_trl));
    y_value3 = y_value(trl_info.R_hit(sel_trl) | trl_info.L_miss(sel_trl));
    EP_CD_RT_curve(:,3,i) = func_compute_prediction_curve(x_value3,y_value3,x_rng);


end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EP_ramp_EP_CD_group,EP_ramp_group_EP_CD] = func_compute_EP_ramp_vs_EP_CD_grouped(ep_cd,ep_ramp,trl_info)% L_lick & R_lick

x_rng = -2:0.5:2;
EP_ramp_EP_CD_group = []; %(9groups,l/r,all/hit/miss,cdt)
early_trls = trl_info.yes_early_test | trl_info.no_early_test;
late_trls = trl_info.yes_late_test | trl_info.no_late_test;

for i = 1 : 4
    switch i
        case 1 % early trls on early cd
            sel_trl = early_trls;
            x_value = ep_ramp(sel_trl,1);
            y_value = ep_cd(sel_trl,1);
        case 2 % late trls on early cd
            sel_trl = late_trls;
            x_value = ep_ramp(sel_trl,1);
            y_value = ep_cd(sel_trl,1);
        case 3 % ealy trls on late cd
            sel_trl = early_trls;
            x_value = ep_ramp(sel_trl,2);
            y_value = ep_cd(sel_trl,2);
        case 4 % late trls on late cd
            sel_trl = late_trls;
            x_value = ep_ramp(sel_trl,2);
            y_value = ep_cd(sel_trl,2);
    end

% AL
l_lick_trl = trl_info.L_hit(sel_trl) | trl_info.R_miss(sel_trl);
[EP_ramp_EP_CD_group(:,1,1,i),EP_ramp_group_EP_CD(:,1,1,i)] = func_compute_prediction_curve(x_value(l_lick_trl,1),y_value(l_lick_trl,1),x_rng); % left trials
r_lick_trl = trl_info.R_hit(sel_trl) | trl_info.L_miss(sel_trl);
[EP_ramp_EP_CD_group(:,2,1,i),EP_ramp_group_EP_CD(:,2,1,i)] = func_compute_prediction_curve(x_value(r_lick_trl,1),y_value(r_lick_trl,1),x_rng); % right trials

% hit
l_lick_trl = trl_info.L_hit(sel_trl) ;
[EP_ramp_EP_CD_group(:,1,2,i),EP_ramp_group_EP_CD(:,1,2,i)] = func_compute_prediction_curve(x_value(l_lick_trl,1),y_value(l_lick_trl,1),x_rng); % left trials
r_lick_trl = trl_info.R_hit(sel_trl);
[EP_ramp_EP_CD_group(:,2,2,i),EP_ramp_group_EP_CD(:,2,2,i)] = func_compute_prediction_curve(x_value(r_lick_trl,1),y_value(r_lick_trl,1),x_rng); % right trials

% miss
l_lick_trl = trl_info.L_miss(sel_trl);
[EP_ramp_EP_CD_group(:,1,3,i),EP_ramp_group_EP_CD(:,1,3,i)] = func_compute_prediction_curve(x_value(l_lick_trl,1),y_value(l_lick_trl,1),x_rng); % left miss trials
r_lick_trl = trl_info.R_miss(sel_trl);
[EP_ramp_EP_CD_group(:,2,3,i),EP_ramp_group_EP_CD(:,2,3,i)] = func_compute_prediction_curve(x_value(r_lick_trl,1),y_value(r_lick_trl,1),x_rng); % right miss trials

end





end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [prediction_curve,x_value]= func_compute_prediction_curve(x_value,y_value,x_rng)
Y_all = [];
X_all = [];
stp = mode(diff(x_rng));
for i_bin = x_rng
    i_trials = find(x_value(:,1)>(i_bin-stp/2) & x_value(:,1)<=(i_bin+stp/2));
    Y_mean = mean(y_value(i_trials,1));
    X_mean = mean(x_value(i_trials,1));

    Y_all(end+1,:) = [Y_mean];
    X_all(end+1,:) = [X_mean];
end
prediction_curve = Y_all;
x_value = X_all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x_value,prediction_curve,nn]= func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng)
Y_all = [];
X_all = [];
stp = mode(diff(x_rng));
n = 1;
for i_bin = x_rng
    i_trials = find(x_value(:,1)>(i_bin-stp/2) & x_value(:,1)<=(i_bin+stp/2));
    Y_mean = mean(y_value(i_trials,1),'omitmissing');
    X_mean = mean(x_value(i_trials,1),'omitmissing');

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xx,EP_lick_curve] = func_compute_EP_vs_lick_pooltrial(x_rng,EP,trl_info_allsession,region,min_trl_cut)
num_session = size(EP,1);
if strcmp(region,'alm')
    i_region = 1;
elseif strcmp(region,'th')
    i_region = 2;
end

for i = 1 : 4
    x_value = [];
    y_value = [];
    for i_sess = 1 : num_session
        trl_info = trl_info_allsession{i_sess,1}{1,1};
        EP_tmp = EP{i_sess,1}{1,i_region}; %(trl,early/late)

        early_trls = trl_info.yes_early_test | trl_info.no_early_test;
        late_trls = trl_info.yes_late_test | trl_info.no_late_test;

        switch i
            case 1 % early trls on early cd
                sel_trl = early_trls;
                x_value = cat(1,x_value,[EP_tmp(sel_trl,1),ones(sum(sel_trl),1)*i_sess]);
            case 2 % late trls on early cd
                sel_trl = late_trls;
                x_value = cat(1,x_value,[EP_tmp(sel_trl,1),ones(sum(sel_trl),1)*i_sess]);
            case 3 % ealy trls on late cd
                sel_trl = early_trls;
                x_value = cat(1,x_value,[EP_tmp(sel_trl,2),ones(sum(sel_trl),1)*i_sess]);
            case 4 % late trls on late cd
                sel_trl = late_trls;
                x_value = cat(1,x_value,[EP_tmp(sel_trl,2),ones(sum(sel_trl),1)*i_sess]);
        end

        y_value = cat(1,y_value,trl_info.R_hit(sel_trl) | trl_info.L_miss(sel_trl));

    end

    [~,EP_lick_curve_tmp,nn] = func_compute_prediction_curve_pooltrial(x_value,y_value,x_rng); % right
    EP_lick_curve_tmp(nn<min_trl_cut,:) = NaN;
    EP_lick_curve(:,:,i) = EP_lick_curve_tmp;
    x = x_rng;
    x(nn<min_trl_cut) = NaN;
    xx(:,i) = x;
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xx,EP_ramp_RT_curve,mtrx] = func_compute_EP_vs_RT_pooltrials(x_rng,EP_allsession,trl_info_allsession,region,min_trl_cut,group_num,RT_cutoff)

num_session = size(EP_allsession);
if strcmp(region,'alm')
    i_region = 1;
elseif strcmp(region,'th')
    i_region = 2;
end



% method 2 : pool trials together, split ramping based on prctiles, no RT offset
group_edge = 0:floor(100/group_num):100;
if group_edge(end)< 100
    group_edge(end) = 100;
end

mtrx = [];
for i = 1 : 4
    ramp_grouped_tmp = cell(1,group_num);
    RT_group_tmp  = cell(1,group_num);

    for i_sess = 1 : num_session
        trl_info = trl_info_allsession{i_sess,1}{1,1};
        EP_tmp = EP_allsession{i_sess,1}{1,i_region};% trial order is sorted

        RT_tmp = trl_info.video_RT;

        early_train = trl_info.yes_early_correct_train | trl_info.no_early_correct_train;
        late_train = trl_info.yes_late_correct_train | trl_info.no_late_correct_train;
        early_trls = trl_info.yes_early_test | trl_info.no_early_test;
        late_trls = trl_info.yes_late_test | trl_info.no_late_test;

        switch i
            case 1 % early trls on early cd

                sel_trl_test = early_trls;
                x_value_tmp = [EP_tmp(sel_trl_test,1),ones(sum(sel_trl_test),1)*i_sess];
                y_value_tmp = RT_tmp(sel_trl_test,1);

                x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
                y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

                x_edge = prctile(x_value_tmp(:,1),group_edge);
                trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

                for i_grp = 1 : size(trials_group,2)
                    ramp_grouped_tmp{1,i_grp} = cat(1,ramp_grouped_tmp{1,i_grp},x_value_tmp(trials_group(:,i_grp),:));
                    RT_group_tmp{1,i_grp} = cat(1,RT_group_tmp{1,i_grp},y_value_tmp(trials_group(:,i_grp),1));
                end

            case 2 % late trls on early cd

                sel_trl_test = late_trls;
                x_value_tmp = [EP_tmp(sel_trl_test,1),ones(sum(sel_trl_test),1)*i_sess];
                y_value_tmp = RT_tmp(sel_trl_test,1);

                x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
                y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

                x_edge = prctile(x_value_tmp(:,1),group_edge);
                trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

                for i_grp = 1 : size(trials_group,2)
                    ramp_grouped_tmp{1,i_grp} = cat(1,ramp_grouped_tmp{1,i_grp},x_value_tmp(trials_group(:,i_grp),:));
                    RT_group_tmp{1,i_grp} = cat(1,RT_group_tmp{1,i_grp},y_value_tmp(trials_group(:,i_grp),1));
                end
            case 3 % ealy trls on late cd

                sel_trl_test = early_trls;
                x_value_tmp = [EP_tmp(sel_trl_test,2),ones(sum(sel_trl_test),1)*i_sess];
                y_value_tmp = RT_tmp(sel_trl_test,1);

                x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
                y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

                x_edge = prctile(x_value_tmp(:,1),group_edge);
                trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

                for i_grp = 1 : size(trials_group,2)
                    ramp_grouped_tmp{1,i_grp} = cat(1,ramp_grouped_tmp{1,i_grp},x_value_tmp(trials_group(:,i_grp),:));
                    RT_group_tmp{1,i_grp} = cat(1,RT_group_tmp{1,i_grp},y_value_tmp(trials_group(:,i_grp),1));
                end
            case 4 % late trls on late cd

                sel_trl_test = late_trls;
                x_value_tmp = [EP_tmp(sel_trl_test,2),ones(sum(sel_trl_test),1)*i_sess];
                y_value_tmp = RT_tmp(sel_trl_test,1);
                
                x_value_tmp(y_value_tmp>RT_cutoff,:) = [];
                y_value_tmp(y_value_tmp>RT_cutoff,:) = [];

                x_edge = prctile(x_value_tmp(:,1),group_edge);
                trials_group = x_value_tmp(:,1) > x_edge(1:end-1) & x_value_tmp(:,1) <= x_edge(2:end); % return n X group of logical matrix

                for i_grp = 1 : size(trials_group,2)
                    ramp_grouped_tmp{1,i_grp} = cat(1,ramp_grouped_tmp{1,i_grp},x_value_tmp(trials_group(:,i_grp),:));
                    RT_group_tmp{1,i_grp} = cat(1,RT_group_tmp{1,i_grp},y_value_tmp(trials_group(:,i_grp),1));
                end
        end
    end

    for i_grp = 1 : group_num
        x_tmp= ramp_grouped_tmp{1,i_grp};
        y_tmp = RT_group_tmp{1,i_grp};

        xx(i_grp,1,i) = mean(x_tmp(:,1),'omitmissing');
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
        xx(i_grp,2,i) = X_std;

        Y_std = std(Y_iBtstrp,'omitmissing');
        EP_ramp_RT_curve(i_grp,2,i) = Y_std;

    end
    
    % union all trials in a plain matrix for anova
    for i_grp = 1 : group_num
        tmp = [RT_group_tmp{1,i_grp},ramp_grouped_tmp{1,i_grp},ones(size(RT_group_tmp{1,i_grp},1),1)*i_grp,ones(size(RT_group_tmp{1,i_grp},1),1)*i];
        mtrx = cat(1,mtrx,tmp);
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%



