% 3.1 Merging Scenes
clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
rotation = eye(3, 3);
translation = zeros(3, 1);
target = load_pcd(0);
merged_frame = target;
merged_color = ones(1,size(target,2));
for i = 1:99
    fprintf("Iter:%d\n",i);
    source=load_pcd(i);
    [R, t] = ICP_variants(source,target, 'uniform');
    rotation = R * rotation;
    translation = bsxfun(@plus, R * translation, t);
    source_transformed=bsxfun(@plus, rotation * source, translation);
    merged_frame = [merged_frame source_transformed];
    merged_color = [merged_color ones(1,size(source_transformed,2))*(i+1)];
    target = load_pcd(i);
end
save('merging_scenes_1.mat','merged_frame','merged_color')
show_frame(merged_frame,merged_color);
function [pcd_data]=load_pcd(index)
filepath = sprintf('Data/data/%010d.pcd',index);
pcd_data = readPcd(filepath);
pcd_data = pcd_data(:,1:3)';
pcd_data = pcd_data(:, pcd_data(3,:) < 2);
end

function show_frame(frame,C)
fscatter3(frame(1,:)', frame(2,:)', frame(3,:)',C');
rotate3d on
end
    
    
    
    
   