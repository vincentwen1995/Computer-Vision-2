clc;close all;
addpath('SupplementalCode/');
load('merging_scenes_1.mat')
frames=downsample(merged_frame',100)';
colors=downsample(merged_color',100)';
show_frame(frames,colors);

