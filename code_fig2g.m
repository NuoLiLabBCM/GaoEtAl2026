% This code plots fig 2g and extended fig 3i

load('fig2g.mat')



%% plot average behavior trace (bin) across animal and sessions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delay_combo = [1 2];
bin_size = 20;
i_sel_trace = 1:19;

figure('Position',[200 200 500 800])
x_lim = [-100 200];

subplot(4,1,1)
ylabel('performance')
xlabel('trial aligned to delay change')
ylim([0 1])
xlim(x_lim)
hold on
[bin_trl,bin_trace_avg,bin_trace_sem] = func_compute_bin_trace(moving_trace_test(i_sel_trace),'average_hit_trace',bin_size,0);
plot_bin_trace_across_session(bin_trl,bin_trace_avg,bin_trace_sem,x_lim,[0 0 0])
hold off

subplot(4,1,2)
ylabel('ignore rate')
xlabel('trial aligned to delay change')
ylim([0 1])
xlim(x_lim)
hold on
[bin_trl,bin_trace_avg,bin_trace_sem] = func_compute_bin_trace(moving_trace_test(i_sel_trace),'average_ignore_trace',bin_size,0);
plot_bin_trace_across_session(bin_trl,bin_trace_avg,bin_trace_sem,x_lim,[0 0 0])
hold off

subplot(4,1,3)
ylabel('Early lick rate')
xlabel('trial aligned to delay change')
ylim([0 1])
xlim(x_lim)
hold on
[bin_trl,bin_trace_avg,bin_trace_sem] = func_compute_bin_trace(moving_trace_test(i_sel_trace),'average_lickEarly_trace',bin_size,0);
plot_bin_trace_across_session(bin_trl,bin_trace_avg,bin_trace_sem,x_lim,[0 0 0])
hold off


subplot(4,1,4)
ylabel(' delta RT trace')
xlabel('trial aligned to delay change')
xlim(x_lim);ylim([-0.025 0.015])
hold on
[bin_trl,bin_trace_avg,bin_trace_sem] = func_compute_bin_trace(moving_trace_test(i_sel_trace),'average_delta_RT_trace',bin_size,0);
plot_bin_trace_across_session(bin_trl,bin_trace_avg,bin_trace_sem,x_lim,[0 0 0])
hold off



%% user-defined functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_trace,avg_behavior]= func_compute_moving_trace_separate_delay(sel_behavior,trl_delay_change,moving_window)
    average_trace = nan(1,length(sel_behavior));
    average_trace(1:trl_delay_change-1) = movmean(sel_behavior(1:trl_delay_change-1),moving_window,'omitnan');
    % average_trace(trl_delay_change:end) = movmean(sel_behavior(trl_delay_change:end),[moving_window-1 0],'omitnan');
    average_trace(trl_delay_change:end) = movmean(sel_behavior(trl_delay_change:end),moving_window,'omitnan');

    avg_behavior = mean(sel_behavior,'omitnan');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [trl,average_trace,sem_trace,trace] = func_compute_behavior_trace(moving_trace,sel_trace_name)
    full_trl = [-200:450]; 

    % average_hit_trace
    trace = zeros(size(moving_trace,1),length(full_trl));
    counts = zeros(size(moving_trace,1),length(full_trl));
    for i_ss = 1 : size(moving_trace,1)
        trl_align_delay_change = moving_trace(i_ss,1).trl_align_delay_change;
        
        common_trls = intersect(full_trl,trl_align_delay_change);
        first_idx = find(full_trl == common_trls(1));
        end_idx = find(full_trl == common_trls(end));

        sel_idx = ismember(trl_align_delay_change,common_trls);
        tmp = moving_trace(i_ss,1).(sel_trace_name)(sel_idx);

        trace(i_ss,first_idx:end_idx) = tmp;
        counts(i_ss,first_idx:end_idx) = 1;
    end

    average_trace = sum(trace,1,'omitmissing') ./ sum(counts,1);
    sem_trace = zeros(size(average_trace));
    for i_trl = 1 : length(average_trace)
        
        sem_trace(1,i_trl) = std(trace(counts(:,i_trl)==1,i_trl),'omitmissing')./ sqrt(sum(counts(:,i_trl)==1));
    end

    trace(counts==0) = NaN;
    % get rid of excessive trials
    
    good_trl = find(~isnan(average_trace));
    trl = full_trl(good_trl);
    average_trace = average_trace(good_trl);
    sem_trace = sem_trace(good_trl) ;

    average_trace(trl==0) = NaN;
    sem_trace(trl==0) = NaN;

    trace = trace(:,good_trl);
    trace(trl==0) = NaN;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_moving_trace_across_session(trl,mean_trace,sem_trace,x_lim,color)

sel_trl = trl>= x_lim(1) & trl <= x_lim(2);
trl = trl(sel_trl);
mean_trace = mean_trace(sel_trl);
sem_trace = sem_trace(sel_trl) ;
avg = mean(mean_trace(trl<=0),'omitnan');
% plot(trl,mean_trace,'color',color,'LineWidth',2)
plot(trl,mean_trace,'color',color)
plot([trl(1) trl(end)], [avg avg],'Color','b','LineStyle','--')

up_border = mean_trace + sem_trace;
low_border = mean_trace - sem_trace;

fill([trl(trl<0) flip(trl(trl<0))],[low_border(trl<0) flip(up_border(trl<0))],0.7*color,'FaceAlpha',0.3,'EdgeColor','none')
fill([trl(trl>0) flip(trl(trl>0))],[low_border(trl>0) flip(up_border(trl>0))],0.7*color,'FaceAlpha',0.3,'EdgeColor','none')

plot([0 0], [min(mean_trace) max(mean_trace)*1.2])

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_moving_trace_across_session_simple(trl,mean_trace,sem_trace,x_lim,color)

sel_trl = trl>= x_lim(1) & trl <= x_lim(2);
trl = trl(sel_trl);
mean_trace = mean_trace(sel_trl);
sem_trace = sem_trace(sel_trl) ;
avg = mean(mean_trace(trl<=0),'omitnan');
% plot(trl,mean_trace,'color',color,'LineWidth',2)
plot(trl,mean_trace,'color',color)
plot([trl(1) trl(end)], [0 0],'Color','b','LineStyle','-')

% fill([trl(trl<0) flip(trl(trl<0))],[low_border(trl<0) flip(up_border(trl<0))],0.7*color,'FaceAlpha',0.3,'EdgeColor','none')
% fill([trl(trl>0) flip(trl(trl>0))],[low_border(trl>0) flip(up_border(trl>0))],0.7*color,'FaceAlpha',0.3,'EdgeColor','none')

plot([0 0], [min(mean_trace) max(mean_trace)*1.2],'b')

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bin_trl,bin_trace_avg,bin_trace_sem] = func_compute_bin_trace(moving_trace,sel_trace_name,bin_size,diff_flag)

[trl,~,~,trace] = func_compute_behavior_trace(moving_trace,sel_trace_name);

% before delay change
bin_trl_before = zeros(1,round(length(trl(trl<=0))/bin_size)); 
bin_trace_avg_before = zeros(size(bin_trl_before));
bin_trace_sem_before = bin_trace_avg_before;

for i_bin = 1 : length(bin_trl_before)
    sel_trl = trl >= 0-(i_bin*bin_size) & trl < 0+bin_size-i_bin*bin_size;
    bin_trl_before(1,end-i_bin+1) = ceil(mean(trl(sel_trl),'omitnan'));
    bin_trace_avg_before(1,end-i_bin+1) = mean(trace(:,sel_trl),'all','omitnan');
    tmp = mean(trace(:,sel_trl),2,'omitnan');
    bin_trace_sem_before(1,end-i_bin+1) = std(tmp,'omitmissing')./ sqrt(sum(~isnan(tmp)));
    
end

% after delay change
bin_trl_after = zeros(1,round(length(trl(trl>0))/bin_size)); 
bin_trace_avg_after = zeros(size(bin_trl_after));
bin_trace_sem_after = bin_trace_avg_after;

for i_bin = 1 : length(bin_trl_after)
    sel_trl = trl >= 1+(i_bin*bin_size)-bin_size & trl < 0+(i_bin*bin_size);
    bin_trl_after(1,i_bin) = round(mean(trl(sel_trl),'omitnan'));
    bin_trace_avg_after(1,i_bin) = mean(trace(:,sel_trl),'all','omitnan');
    tmp = mean(trace(:,sel_trl),2,'omitnan');
    bin_trace_sem_after(1,i_bin) = std(tmp,'omitmissing')./ sqrt(sum(~isnan(tmp)));
    
end

% concatenate bin trace
bin_trl = [bin_trl_before bin_trl_after];
if diff_flag == 0
    bin_trace_avg = [bin_trace_avg_before bin_trace_avg_after];
elseif diff_flag == 1
    bin_trace_avg = [bin_trace_avg_before bin_trace_avg_after] - mean(bin_trace_avg_before);
end    
bin_trace_sem = [bin_trace_sem_before bin_trace_sem_after];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_bin_trace_across_session(trl,mean_trace,sem_trace,x_lim,color)

avg_before = mean(mean_trace(trl>= x_lim(1)&trl<=0),'omitnan');

sel_trl = trl>= x_lim(1) & trl <= x_lim(2);
trl = trl(sel_trl);
mean_trace = mean_trace(sel_trl);
sem_trace = sem_trace(sel_trl) ;

hold on
errorbar(trl,mean_trace,sem_trace,'o','LineWidth',2,'CapSize',0,'Color',color)

plot([trl(1) trl(end)], [avg_before avg_before],'Color','b','LineStyle','--','LineWidth',2)

plot([0 0], [min(mean_trace) max(mean_trace)*1.2],'Color','r','LineWidth',2)

set(gca,'tickDir','out')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
