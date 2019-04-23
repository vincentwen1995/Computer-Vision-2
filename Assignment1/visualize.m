clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
load('merging_scenes_1.mat')
frames=downsample(merged_frame',100)';
colors=downsample(merged_color',100)';
show_frame(frames,colors);

