function [obj, combined_img] = func_compute_cb2th_obj(dir,dcn)
load(dir,'all_data')
data = all_data.(dcn); % 10 um

%% compute multiple planes along z axis
range = [625:675;650:700;675:725;700:750;725:775];
combined_img = struct('img',[]);
combined_img(1,1).img = im2uint8(zeros(800,1140));
combined_img(2,1).img = im2uint8(zeros(800,1140));
combined_img(3,1).img = im2uint8(zeros(800,1140));
combined_img(4,1).img = im2uint8(zeros(800,1140));
combined_img(5,1).img = im2uint8(zeros(800,1140));
combined_img(1,1).plane = 650;
combined_img(2,1).plane = 675;
combined_img(3,1).plane = 700;
combined_img(4,1).plane = 725;
combined_img(5,1).plane = 750;

n = zeros(5,1);
    for i_stack = 1 : length(data)
        section_all = data(i_stack).section_all;
        for i_section = 1 : length(section_all)
            idx = find(sum(range == section_all(i_section),2));
            for i_img = 1 : length(idx)
                combined_img(idx(i_img),1).img = combined_img(idx(i_img),1).img + im2uint8(data(i_stack).image_tif{i_section}*100) ;
                n(idx(i_img),1) = n(idx(i_img),1) + 1;
            end
        end
    end
    for i_img = 1 : size(range,1)
        combined_img(i_img).img = combined_img(i_img).img ./ n(i_img,1);
    end
%%
hypothalamus_obj = func_load_atlas_obj('HY');
%%
for i_img = 1 : size(range,1)
    % overlay
    if strcmp(dcn,'FN')
        im_ch = imadjust(combined_img(i_img).img,[11/255 16/255],[],1);
        threshold = 250;
    elseif strcmp(dcn,'DN')
        im_ch = imadjust(combined_img(i_img).img,[12/255 17/255],[],1);
        threshold = 200;
    end
    % outline the densest labeled region and get outline
    x = im_ch;
    y=conv2(ones(5,5),double(x));
    y=(y>threshold);
    [xq,yq] = find(y);
    xy_ind = find(y);
    in = inpolygon(xq,yq,[300 580 580 300]+2,[570 570 800 800]+2); % rough TH area
%%
    zq = combined_img(i_img).plane *ones(size(xq));
    out = inpolyhedron(hypothalamus_obj.f,hypothalamus_obj.v,[zq,xq,yq]*10);
%%
    all_idx = zeros(numel(y),1);
    all_idx(xy_ind(in)) = 1;
    all_idx(xy_ind(out)) = 0;
    y(~all_idx) = 0;
    y = imopen(y,strel('disk',5));
    y = imclose(y,strel('disk',5));


    [B,L,N,A] = bwboundaries(y);

    if strcmp(dcn,'DN') % remove the outlier area for DN
        B = B{1};
        L(L>1) = 0;

    end

    BB = {};
    if iscell(B)
        for i_label = 1 : 2 % only keep maximun 2 contours
            try
                BB{i_label,1} = B{i_label} - 2; % compensate 2 extra pixels for each dimension caused by conv2
            end
        end
    else
        BB{1} = B-2; % compensate 2 extra pixels for each dimension caused by conv2
    end

    L(L>2) = 0;
    L = L(3:end-2,3:end-2); % compensate 2 extra pixels for each dimension caused by conv2
    % save outline
    
    combined_img(i_img).boundary = BB;
    combined_img(i_img).area = L;
end


%% construct 3d volume based on shape
xyz_coord = [];
for i_plane = 1 : length(combined_img)
    area = combined_img(i_plane).area;
    [xx,yy] = ind2sub(size(area),find(area>0));
    xyz_coord_tmp = [xx,yy];
    xyz_coord_tmp =[xyz_coord_tmp,i_plane*ones(size(xyz_coord_tmp,1),1)];

    xyz_coord = [xyz_coord;xyz_coord_tmp];
end
mtrx = zeros(800,1140,5); % 5 planes with 25 planes in gap
xyz_idx = sub2ind(size(mtrx),xyz_coord(:,1),xyz_coord(:,2),xyz_coord(:,3));
mtrx(xyz_idx) = 1;
mtrx = smooth3(mtrx);

% interpolate mtrx to (800,1140,650:750)
[x,y,z] = meshgrid(1:1140,1:800,1:5);
[xq,yq,zq] = meshgrid(1:1140,1:800,1:1/25:5);
new_mtrx = interp3(x,y,z,mtrx,xq,yq,zq);

full_mtrx = zeros(800,1140,1132);
full_mtrx(:,:,650:750) = new_mtrx;

obj = struct();
[x,y,z] = meshgrid(1:1140,1:800,1:1132);
[f,v] = isosurface(x,y,z,full_mtrx);
obj.f = f;
obj.v = v;
obj.v = [obj.v(:,3),obj.v(:,2),obj.v(:,1)];
obj.v(:,3) = 1140 - obj.v(:,3);
obj.full_mtrx = full_mtrx;
end