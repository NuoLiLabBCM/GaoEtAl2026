function alm_2d = func_load_alm_2d(dir)

    alm_3d = niftiread(dir);  % in 100um
    alm_3d = permute(alm_3d,[1 3 2]);
    alm_3d = smooth3(alm_3d);
    
    region_edge = mean(alm_3d,3);
    % get the region border
    region_edge = edge(imbinarize(region_edge,0.1));
    alm_2d = region_edge * 2^16;

end