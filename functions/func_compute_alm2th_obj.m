function [obj,combined_img] = func_compute_alm2th_obj(dir)
load(dir,'all_data')
data = all_data.alm; % 10 um

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

for i_img = 1 : size(range,1)
    % overlay
    im_ch = imadjust(combined_img(i_img).img,[8/255 10/255],[],1);

    % outline the densest labeled region and get outline
    x = im_ch;
    y=conv2(ones(10,10),double(x));
    y=(y>10);
    [xq,yq] = find(y);
    xy_ind = find(y);
    in = inpolygon(xq,yq,[300 550 550 300]+4,[570 570 750 750]+4); % rough TH area
    all_idx = zeros(numel(y),1);
    all_idx(xy_ind(in)) = 1;
    y(~all_idx) = 0;
    y = imopen(y,strel('disk',10));
    y = imclose(y,strel('disk',10));
    [B,L,N,A] = bwboundaries(y);
    size_all = [];
    for i=1:size(B,1)
        size_all(i,1)=sum(sum(L==i));
    end

%     i_label = find(size_all==max(size_all));
%     B = B{i_label} - 2; % compensate 2 extra pixels for each dimension caused by conv2
%     L(L~=i_label) = 0;
    for ib = 1 : length(B)
        B{ib} = B{ib} - 4; % compensate 4 extra pixels for each dimension caused by conv2
    end
    
    L = L(5:end-5,5:end-5); % compensate 5 extra pixels for each dimension caused by conv2
    
    % plane 5 contain 3 contours, only use largest 2
    if i_img == 5
        B = B(1:2);
    end
    L(L>2) = 0;
    % save outline
    
    combined_img(i_img).boundary = B;
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