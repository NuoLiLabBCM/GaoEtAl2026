function [x_CCF y_CCF] = func_Im2CCF_num(unit_raw_xPos, unit_raw_yPos, im_raw, im_warp_points, im_fiximsz)

unit_raw_xPos = round(unit_raw_xPos);
unit_raw_yPos = round(unit_raw_yPos);


% generate linking image
im_link_raw = zeros(size(im_raw));

im_link_raw(unit_raw_yPos,unit_raw_xPos) = 100;

im_link_raw = imgaussfilt(im_link_raw,10);      % sigma = 10 pixles

im_CCF = func_Bspline_warp_im(im_link_raw, im_warp_points, im_fiximsz);

im_CCF(im_CCF<(max(max(im_CCF))*.1))=0;

[ii,jj] = ndgrid(1:size(im_CCF,1),1:size(im_CCF,2));
x_CCF = sum(jj(:).*im_CCF(:))/sum(im_CCF(:));
y_CCF = sum(ii(:).*im_CCF(:))/sum(im_CCF(:));

return
