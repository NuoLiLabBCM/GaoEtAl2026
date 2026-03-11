function [MUA_allch] = func_compute_MUA(file_list, N_file)


MUA_count = [];

N_file = min([N_file size(file_list,1)]);
selected_file = randsample(size(file_list,1),N_file);

for i_file = selected_file'
    
    disp(file_list{i_file})
    load(file_list{i_file})
    
    for i_ch = 1:64
        voltage = ch_MUA(TimeStamps<2.5,i_ch);
        t = TimeStamps(TimeStamps<2.5);
        
        threshold = 6*std(voltage);
        
        if threshold>0
            i_cross = find(voltage<-threshold);
            i_event = i_cross(find(diff(i_cross)>1));
            %plot(t,voltage,'b'); hold on
            %plot(t(i_event),voltage(i_event),'or');

            MUA_count(i_file,i_ch) = length(i_event)/range(t);

            
        else
            MUA_count(i_file,i_ch) = 0;
        end
        
    end
    
end
MUA_allch = MUA_count;

return

