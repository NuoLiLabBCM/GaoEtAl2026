function [cell_type] = func_get_cell_type(waveform)

% Intan system, Baylor (Guo & Li 2014 criteria), sampling rate=20000
waveform_tmp = mean(waveform);
waveform_tmp = waveform_tmp/norm(waveform_tmp);
[wave_min i_peak_min] = min(waveform_tmp);
[wave_max i_peak_max] = max(waveform_tmp(i_peak_min:end));
spk_width_tmp = i_peak_max;

if spk_width_tmp > round(9/19531*20000)
    cell_type = 1;
elseif spk_width_tmp < round(7/19531*20000)
    cell_type = 2;
else
    cell_type = 0;
end

