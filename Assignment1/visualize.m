clc;close all;
addpath('SupplementalCode/');
if exist('merging_scenes_1.mat')
load('merging_scenes_1.mat')
else 
    run('merging_scenes_1.m')
end
frames=downsample(merged_frame',100)';
colors=downsample(merged_color',100)';
show_frame(frames,colors);

