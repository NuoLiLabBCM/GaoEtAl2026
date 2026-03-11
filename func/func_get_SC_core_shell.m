function [cell_location] = func_get_SC_core_shell(CCF_x, CCF_y, CCF_slice)

% Assuming input coordinates are from alignment pipelines using 2D Allen
% template brain at 10um resolution. The 3D template brain & CCF masks
% are 20 um resolution.
%
% Output:
% 1 -- core
% 2 -- shell
% 0 -- neither
% -1 -- outside SC
% 

% ---------------- flip all units into the left hemisphere, where masks are defined ------------
CCF_width = 1140; % size of CCF image, 10um volume
CCF_midline = 570;
i_units = find(CCF_x>CCF_midline);
CCF_x(i_units,1) = CCF_width-CCF_x(i_units,1);



file_mask_core = '../../../Data Anatomy/Data_Analysis_ALM_SC_Anatomy/ROImask_SCcore_3D.tif';
file_mask_shell = '../../../Data Anatomy/Data_Analysis_ALM_SC_Anatomy/ROImask_SCshell_3D.tif';

ara_annotation = '../../../Data Anatomy/Data_Analysis_ALM_SC_Anatomy/Annotation_new_10_ds2_16bit_updated.tif';
annotation_ara = func_loadTifFast(ara_annotation);
SCmask_ara = (annotation_ara==26 | annotation_ara==42 | annotation_ara==17 | annotation_ara==10 | annotation_ara==494 | annotation_ara==503 | annotation_ara==511 | annotation_ara==851 | annotation_ara==842); 


mask_core = func_loadTifFast(file_mask_core);
mask_shell = func_loadTifFast(file_mask_shell);

row_ind = round(CCF_y/2);
col_ind = round(CCF_x/2);
slice_ind = round(CCF_slice/2);

linear_ind = row_ind + (col_ind-1)*size(mask_core,1) + (slice_ind-1)*size(mask_core,1)*size(mask_core,2);
is_core = (mask_core(linear_ind)>0);
is_shell = (mask_shell(linear_ind)>0);
is_SC = SCmask_ara(linear_ind);


cell_location = zeros(size(CCF_x));
cell_location(is_core)=1;
cell_location(is_shell)=2;
cell_location(~is_SC)=-1;




