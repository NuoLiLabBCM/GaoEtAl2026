function [signal_1_noSpk spk_times] = func_get_Vm(TimeStamp, signal_1, spike_width);

% clipping spikes from Vm
signal_1_noSpk = [];
spk_times = [];
for i_rep = 1:size(signal_1,1)
    signal_tmp = signal_1(i_rep,:);
    dVm_dt = diff(signal_tmp);
    i_spk_onset = find(dVm_dt>(5*std(dVm_dt)));
    
    
    i_discard = find(diff(i_spk_onset)==1);
    i_spk_onset(i_discard+1)=[];
    
    
    % discard events that do not exceed an amplitude threshold
    i_discard =[];
    for i_spk = 1:length(i_spk_onset)
        i_snipt = find(TimeStamp>(TimeStamp(i_spk_onset(i_spk))) & TimeStamp<(TimeStamp(i_spk_onset(i_spk))+spike_width));
        if max(signal_tmp(i_snipt))<=(mean(signal_tmp)+std(signal_tmp)*3.5)
            i_discard(end+1,1) = i_spk;
        end
    end
    i_spk_onset(i_discard)=[];
    
    
    %plot(TimeStamp,signal_tmp); hold on
    if ~isempty(i_spk_onset)
%         plot(TimeStamp(i_spk_onset),signal_tmp(i_spk_onset),'*r')
        
        for i_spk = 1:length(i_spk_onset)
            i_snipt = find(TimeStamp>(TimeStamp(i_spk_onset(i_spk))) & TimeStamp<(TimeStamp(i_spk_onset(i_spk))+spike_width));
            if signal_tmp(i_snipt(1))~=signal_tmp(i_snipt(end))
                signal_tmp(i_snipt) = signal_tmp(i_snipt(1)):((signal_tmp(i_snipt(end))-signal_tmp(i_snipt(1)))/(length(i_snipt)-1)):signal_tmp(i_snipt(end));
            else
                signal_tmp(i_snipt) = zeros(size(i_snipt))+signal_tmp(i_snipt(1));
            end
        end
        %plot(TimeStamp,signal_tmp,'g')
    end
    signal_1_noSpk(i_rep,:) = signal_tmp;
    spk_times{i_rep,1} = TimeStamp(i_spk_onset)';
    
end
