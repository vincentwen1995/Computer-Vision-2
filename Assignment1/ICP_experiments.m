clear all
close all


addpath('SupplementalCode')
addpath('Data')
option = 'normal';
sample_rate = 5;
% [R, t, stats] = ICP_variants(source, target, option, sample_rate);
% Load data.
% load('source.mat')
% load('target.mat')

% Load normals of '0000000099.pcd'.
normals = readPcd('0000000099_normal.pcd');
normals = normals(:, 1:3);
nan_inds = find(isnan(sum(normals, 2)) == 1);
normals(nan_inds, :) = [];
normals = normals';

% Load data.
source = readPcd('0000000099.pcd');
source = source(:, 1:3);
source(nan_inds, :) = [];
far_inds = find(source(:, 3) > 2 == 1);
source(far_inds, :) = [];
normals(:, far_inds) = [];
source = source';

target = readPcd('0000000098.pcd');
target = target(:, 1:3);
target(target(:, 3) > 2, :) = [];
target = target';

[R, t, stats] = ICP_variants(source, target, option, normals);
tr = bsxfun(@plus, R * source, t);
[dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
rms = sqrt(mean(dist.^2));
figure
hold on
plot3(target(1, :), target(2, :), target(3, :), 'k.')
plot3(tr(1, :), tr(2, :), tr(3, :), 'r.')
hold off