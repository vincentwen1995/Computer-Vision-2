clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
load('merging_scenes_2.mat')
frames=downsample(merged_frame',50)';
colors=downsample(merged_color',50)';
show_frame(frames,colors);

