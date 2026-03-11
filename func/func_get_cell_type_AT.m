function [cell_type] = func_get_cell_type(waveform)

% Intan system, Baylor (Guo & Li 2014 criteria), sampling rate=20000
waveform_tmp = mean(waveform);
waveform_tmp = waveform_tmp/norm(waveform_tmp);
[wave_min i_peak_min] = min(waveform_tmp);
[wave_max i_peak_max] = max(waveform_tmp(i_peak_min:end));
spk_width_tmp = i_peak_max;

if i_contra
    cell_type = 1;
elseif i_ipsi
    cell_type = 2;
else
    cell_type = 0;
end

