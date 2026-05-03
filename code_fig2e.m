% This code plots fig 2e

load('fig2e.mat')
%%
figure();

func_plot_mean_and_sem(time_bins(time_bins<=4.2),mean_trace(:,time_bins<=4.2,1),[0 0 0],[.7 .7 .7],'none',1);
func_plot_mean_and_sem(time_bins(time_bins<=3.2),mean_trace(:,time_bins<=3.2,2),[.5 .5 .7],[.8 .8 1],'none',1);
func_plot_mean_and_sem(time_bins(time_bins<=3.2),mean_trace(:,time_bins<=3.2,3),[.5 .5 0],[1  1 .5],'none',1);

y_range = [-0.5 1.5];
plot([0 0], y_range, 'k', 'LineWidth', 2);
plot([1.3 1.3], y_range, 'k', 'LineWidth', 2);
plot([1.3+delay_combo(1) 1.3+delay_combo(1)], y_range, 'k--', 'LineWidth', 1);
plot([1.3+delay_combo(2) 1.3+delay_combo(2)], y_range, 'k', 'LineWidth', 2);

xlabel('Time Aligned to Pole Onset (s)');xlim([-0.5 4.5])
ylabel('Activity projection on ramping (a.u.)');ylim([-0.5 1.5])
xticks([0 1.3 2.3 3.3]);
ylim(y_range * 1.05);
set(gca,'TickDir','out');
hold off
legend({'';'-40-0 trls';'';'1-10 trl';'';'80-120 trls'},'Box','off')

box off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  mean_trace = func_get_mean_trace(proj_ramp_trl_base_all,bin_size,delay_combo,i_mode,norm_flg)
time_bins = round([-0.5:0.01:4.5],2);

proj_activity = proj_ramp_trl_base_all{1}(:,:,i_mode);
trial_align_delay_change = proj_ramp_trl_base_all{2}(:,1);

train_trials = proj_ramp_trl_base_all{2}(:,10) | proj_ramp_trl_base_all{2}(:,11);
i_t1 = time_bins>-0.5 & time_bins <= -0.2;
i_t2 = find(time_bins<= (1.3+delay_combo(1)-0.2));
% baseline = mean(proj_activity(i_t1,train_trials),'all','omitmissing');
% amplitude =  mean(proj_activity(i_t2(end),train_trials),'all','omitmissing') - baseline;
% proj_activity = (proj_activity - baseline)./amplitude;
tt = round([repmat(delay_combo(1),sum(trial_align_delay_change<0),1);repmat(delay_combo(2),sum(trial_align_delay_change>=0),1)]+1.3-0.2,2);
if norm_flg == 1 
    idx_mtrx = time_bins==tt;
    proj_activity = proj_activity./ mean(proj_activity(idx_mtrx'),'omitmissing');
end


for i = 1 : size(bin_size,1)
sel_trl = trial_align_delay_change >= bin_size(i,1) & trial_align_delay_change <= bin_size(i,2);
mean_trace(:,i) = mean(proj_activity(:,sel_trl),2,'omitmissing');
end

end