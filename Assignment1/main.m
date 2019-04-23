clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
target=load_pcd(0);
merged_frame=target;
merged_color=ones(1,size(target,2));
target=downsample(target',10)';
for i=1:10:99
    frame=load_pcd(i);
    [R,t]=ICP(frame,target,100,1000);
    frame_tr= R * frame + t;
    merged_frame=[merged_frame frame_tr];
    merged_color=[merged_color ones(1,size(frame,2))*(i+1)];
end
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
