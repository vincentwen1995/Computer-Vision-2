clear all
close all

addpath('SupplementalCode')
addpath('Data')
addpath('Data/data')

%% Load, transform and plot toy data.
% load('source.mat')
% load('target.mat')
%
% [R, t, stats] = ICP_variants(source, target, 'all');
% tr = bsxfun(@plus, R * source, t);
% [dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
% rms = sqrt(mean(dist.^2));
% figure
% hold on
% plot3(source(1, :), source(2, :), source(3, :), '.', 'MarkerSize', 5)
% plot3(target(1, :), target(2, :), target(3, :), '.', 'MarkerSize', 5)
% plot3(tr(1, :), tr(2, :), tr(3, :), '.', 'MarkerSize', 5)
% legend('source', 'target', 'transformed')
% rotate3d on
% view(45, 10)
% saveas(gca, 'results/correct_toy.eps', 'epsc')
% hold off

%% Load, transform and plot frame '00' to '10'.
% % Load normals of '0000000000.pcd', filter and normalize w.r.t. the origin.
% [source, target, normals] = load_frames('00', '10');
% [R, t, stats] = ICP_variants(source, target, 'all');
% tr = bsxfun(@plus, R * source, t);
% [dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
% rms = sqrt(mean(dist.^2));
% figure
% hold on
% plot3(source(1, :), source(2, :), source(3, :), '.', 'MarkerSize', 1.25)
% plot3(target(1, :), target(2, :), target(3, :), '.', 'MarkerSize', 1.25)
% plot3(tr(1, :), tr(2, :), tr(3, :), '.', 'MarkerSize', 1.25)
% legend('source', 'target', 'transformed')
% rotate3d on
% view(0, -90)
% saveas(gca, 'results/correct_frames.eps', 'epsc')
% hold off

%% Compare the variants w.r.t. speed and accuracy

[source, target, normals] = load_frames('00', '30');

[R, t, stats] = ICP_variants(source, target, 'all');
tr = bsxfun(@plus, R * source, t);
[dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
rms = sqrt(mean(dist.^2));
fprintf('Method: all, rms: %f, iters: %d\n', rms, stats.iter);

[R, t, stats] = ICP_variants(source, target, 'uniform');
tr = bsxfun(@plus, R * source, t);
[dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
rms = sqrt(mean(dist.^2));
fprintf('Method: uniform, rms: %f, iters: %d\n', rms, stats.iter);

[R, t, stats] = ICP_variants(source, target, 'random');
tr = bsxfun(@plus, R * source, t);
[dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
rms = sqrt(mean(dist.^2));
fprintf('Method: random, rms: %f, iters: %d\n', rms, stats.iter);

[R, t, stats] = ICP_variants(source, target, 'normal', normals);
tr = bsxfun(@plus, R * source, t);
[dist, ~] = pdist2(target', tr', 'euclidean', 'Smallest', 1);
rms = sqrt(mean(dist.^2));
fprintf('Method: normal, rms: %f, iters: %d\n', rms, stats.iter);




function [source, target, normals] = load_frames(source_name, target_name)
affix = '00000000';
% Load normals of the source, filter and normalize w.r.t. the origin.
normals = readPcd(strcat(affix, source_name, '_normal.pcd'));
normals = normals(:, 1:3);
nan_inds = find(isnan(sum(normals, 2)) == 1);
normals(nan_inds, :) = [];
normals = normals';

<<<<<<< Updated upstream
    % Load data.
    source = readPcd(strcat(affix, source_name, '.pcd'));
    source = source(:, 1:3);
    source(nan_inds, :) = [];
    far_inds = find(source(:, 3) > 2 == 1);
    source(far_inds, :) = [];
    normals(:, far_inds) = [];
    source = source';
%     normals = normals - source;
=======
% Load data.
source = readPcd(strcat(affix, source_name, '.pcd'));
source = source(:, 1:3);
source(nan_inds, :) = [];
far_inds = find(source(:, 3) > 2 == 1);
source(far_inds, :) = [];
normals(:, far_inds) = [];
source = source';
normals = normals - source;
>>>>>>> Stashed changes

target = readPcd(strcat(affix, target_name, '.pcd'));
target = target(:, 1:3);
target(target(:, 3) > 2, :) = [];
target = target';
end