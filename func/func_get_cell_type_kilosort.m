function [cell_type,cur_spike_width] = func_get_cell_type_kilosort(mean_waveform)
% expect the mean waveform to be 1*410 vector,
% which is a concatenated trace from 5 channels,
% the middle one 165-246 is the peak channel,
% sample rate is 30kHz

% Li et al., 2018 criteria: fast spiking 0.00035 intermediate 0.00045 pyramidal
cur_spike_width = func_get_spike_width(mean_waveform);
dendritic_spike = func_get_dendritic_spike(mean_waveform);

if ~dendritic_spike
    if cur_spike_width<= 0.00035
        cell_type = 1; % fast spike
    elseif cur_spike_width >= 0.00035 && cur_spike_width < 0.00045
        cell_type = 2; % intermediate
    elseif cur_spike_width >= 0.00045
        cell_type = 3; % putative pyramidal
    end
else
    cell_type = 4; % putative dendritic spike
end

end

function spike_width = func_get_spike_width(mean_wf)

% expect the mean waveform to be 1*410 vector,
% which is a concatenated trace from 5 channels,
% the middle one 165-246 is the peak channel,
% sample rate is 30kHz
waveform_tmp = mean_wf(1,165:246)/norm(mean_wf(1,165:246));
[x_min ,i_min] =  min(waveform_tmp);
[x_max,i_max ]= max(waveform_tmp(i_min:end));
spike_width = i_max/30000;
end

function  dendritic_spike = func_get_dendritic_spike(waveform)

% dendritic spike the peak happens around 20-25, when general spike
% have the through
waveform_tmp = waveform(1,165:246)/norm(waveform(1,165:246));
[x_max,i_max]= max(waveform_tmp);
if i_max>=20 && i_max <= 25
    dendritic_spike = 1;
else
    dendritic_spike = 0;
end

end



