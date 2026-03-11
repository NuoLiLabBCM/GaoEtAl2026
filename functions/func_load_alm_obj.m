function obj = func_load_alm_obj(dir)
    
    % load alm mask from ALM_border_NuoLi_25um.nii.gz
    alm_3d = niftiread(dir);  % in 25um
    alm_3d = permute(alm_3d,[2 1 3]);
%     alm_3d = alm_3d(:,:,end:-1:1);  % in 25um
    
   % alm_3d = smooth3(alm_3d);
    [xx,yy,zz] = size(alm_3d);
    [x,y,z] = meshgrid(1:yy,1:xx,1:zz);
    
    obj = struct();
    [f,v] = isosurface(x,y,z,alm_3d,0.8);
    obj.v = v;
    obj.f = f;
end