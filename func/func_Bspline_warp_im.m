function im_out = func_Bspline_warp_im(im_raw, d, fiximsz)

parent_directory = pwd;
addpath(genpath(fullfile(parent_directory, 'nonrigid_version23')));


h.pts = d;
h.pts.cur = h.pts.mov;
h.moving = im_raw;

h.tree.mov = [];
h.tree.cur = [];
h.treepts = [];

[h.pts, h.tree, h.current, h.af] = doAfWarpfast(h.pts, h.tree, h.moving, fiximsz);
h.haveaf = 1;

curpts = h.pts.cur(:, [2 1]);
fixpts = h.pts.fix(:, [2 1]);


options.Verbose=false;
options.MaxRef = 5;

[h.O_trans,h.Spacing]         = point_registration(fiximsz,fixpts, curpts, options);
[h.O_trans_inv,h.Spacing_inv] = point_registration(fiximsz,curpts, fixpts, options);

h.havebs = 1;



h.current = bspline_transform(h.O_trans,h.current,h.Spacing,3);
curpts    = bspline_trans_points_double(h.O_trans_inv, h.Spacing_inv, curpts);
h.pts.cur = curpts(:, [2 1]);

if ~isempty(h.tree.cur)
    curtree   = bspline_trans_points_double(h.O_trans_inv, h.Spacing_inv, h.tree.cur(:,[2 1]));
    h.tree.cur = curtree(:, [2 1]);
end


im_out = h.current;

