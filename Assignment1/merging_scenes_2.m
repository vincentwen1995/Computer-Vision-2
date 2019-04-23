% 3.2 Merging Scenes
clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
rotation = eye(3, 3);
translation = zeros(3, 1);
source = load_pcd(0);
merged_frame = source;
merged_color = ones(1,size(source,2));
for i = 1:5:99
    fprintf("Iter:%d\n",i);
    % New frame as target
    target = load_pcd(i);
    % Merged frame as source 
    source= merged_frame;
    [R, t] = ICP_variants(source,target, 'random');
    rotation = R * rotation;
    translation = bsxfun(@plus, R * translation, t);
    merged_frame =bsxfun(@plus, rotation * source, translation);
    merged_frame = [merged_frame target];
    merged_color = [merged_color ones(1,size(target,2))*(i+1)];
end
save('merging_scenes_2.mat','merged_frame','merged_color')
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