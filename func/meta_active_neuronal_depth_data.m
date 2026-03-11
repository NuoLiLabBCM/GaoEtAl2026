Sessions_Name = {

     
     '\ANM341360\20160723\';...  % Left Fastigii recording, hit, right ALM stim, left ALM stim, various protocols. 473nm

     
     '\BAYLORNL12\20170610\';...  % left ALM recording, RL ChR2 500ms
     
     
     '\BAYLORKS5\20190314\';...  % right SC recording
     
     
     };



mice_id_allSessions = {};
for i_session = 1:size(Sessions_Name,1)
    i_str = findstr(Sessions_Name{i_session},'\');
    mice_id_allSessions{i_session,1} = Sessions_Name{i_session}(i_str(1)+1:i_str(2)-1);
end
clear i_session i_str


date_allSessions = {};
for i_session = 1:size(Sessions_Name,1)
    i_str = findstr(Sessions_Name{i_session},'\');
    date_allSessions{i_session,1} = Sessions_Name{i_session}(i_str(2)+1:i_str(3)-1);
end
clear i_session i_str



% this is electrode length under cortex surface, later analyses will compensate for angle and compute real depth
% in units of micrometers, z-axis
recording_depth = [
    

     3127;...%'\ANM341360\20160723\';...  % Left Fastigii recording, hit, right ALM stim, left ALM stim, various protocols. 473nm
         
     
     900;...'\BAYLORNL12\20170610\';...  % left ALM recording, RL ChR2 500ms
     
     
     2500;...'\BAYLORKS5\20190314\';...  % right SC recording

     ];



recording_location = [
       
     % 100 -- left ALM
     % 101 -- right ALM
     
     % 1 -- Fastigii hit
     % -1 -- Fastigii miss
     % 10 -- Fastigii unsure
     % 2 -- Dentate hit
     % -2 -- Dentate miss
     % 20 -- Dentate unsure
     % 3 -- Interposed hit
     % -3 -- Interposed miss
     % 30 -- Interposed unsure
     % 5 -- Dentate & Interposed hit

     % 300 -- left SC
     % 301 -- right SC
     
     1;...%'\ANM341360\20160723\';...  % Left Fastigii recording, hit, right ALM stim, left ALM stim, various protocols. 473nm
     
     
     100;...'\BAYLORNL12\20170610\';...  % left ALM recording, RL ChR2 500ms
     
     301;...'\BAYLORKS5\20190314\';...  % right SC recording
     
     ];






probe_type = [
    
    
    % system    electrode type
    %
    %   system: 
    %       1 -- old recording system
    %       2 -- whisper recording system
    %       3 -- Intan recording system (baylor)
    %
    %   electrode type: 
    %       1   1 -- A32-100-200-177
    %       1   2 -- A32-100-200-413
    %       1   3 -- A32-200-200-413
    %       1   4 -- edge probe, 1x32, 100um spacing
    %       1   5 -- A32-100-400-177, 400 um shank spacing
    %       1   6 -- KSSB1.probe, 32 ch, old system
    %       2   1 -- A32-100-200-177, whisper system lower plug
    %       2   7 -- APIG 64 ch probe, whisper system
    %
    %       3   1-- A32-100-200-177, Intan system lower plug
    %       3   7-- APIG 64 ch probe, Intan system (the site mapping are wrong, for these data, they need to be corrected during analysis
    %       3   8-- NeuroTech DBC64 ch probe, Intan system 



     2      7;...%'\ANM341360\20160723\';...  % Left Fastigii recording, hit, right ALM stim, left ALM stim, various protocols. 473nm
     
     3      8;...'\BAYLORNL12\20170610\';...  % left ALM recording, RL ChR2 500ms
     
     
     3      8;...'\BAYLORKS5\20190314\';...  % right SC recording
     
     
     ];


