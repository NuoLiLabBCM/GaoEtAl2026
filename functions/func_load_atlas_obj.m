function [obj] = func_load_atlas_obj(input)
    % vargin sanity check
    if ~(ischar(input) || iscell(input) ||  isnumeric(input))
        error('input should be Chars, Cells of Chars, or numeric array')
    end

    % load allen structure table tree
    load('.\atlas\structureTreeTable.mat'); % loaded variable is structureTreeTable

    % load faces and vertices from obj files
    obj = struct();
    if ischar(input) || iscell(input)
        [Lia,Lob] = ismember(input,structureTreeTable.acronym); 
        for i_struct = 1 : length(Lia)
            if Lia(i_struct) == 0
                warning([input(i_struct), ' not found in annotated atlas'])
                obj(i_struct,1).region = [];
            else
               obj(i_struct,1).region = structureTreeTable.acronym{Lob(i_struct)};
               obj_name = [num2str(structureTreeTable.id(Lob(i_struct))),'.obj'];
               try
                [v,f] = loadawobj(['.\atlas\Allen_obj_files\',obj_name]);
                obj(i_struct,1).v = v';
                obj(i_struct,1).f = f';
               catch
                   disp(['.\atlas\Allen_obj_files\',obj_name,' not found'])
               end
            end
        end
    elseif isnumeric(input)
        [Lia,Lob] = ismember(input,structureTreeTable.id);
        for i_struct = 1 : length(Lia)
            if Lia(i_struct) == 0
                warning(['id ', num2str(input(i_struct)), ' not found in annotated atlas'])
                obj(i_struct,1).region = [];
            else
               obj(i_struct,1).region = structureTreeTable.acronym{Lob(i_struct)};
               obj_name = [num2str(structureTreeTable.id(Lob(i_struct))),'.obj'];
               try
                [v,f] = loadawobj(['.\atlas\Allen_obj_files\',obj_name]);   
                obj(i_struct,1).v = v';
                obj(i_struct,1).f = f';
                catch
                   disp(['.\atlas\Allen_obj_files\',obj_name,' not found'])
               end

            end

        end
    else
        disp('incorrect format for input')
    end
end