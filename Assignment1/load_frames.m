function [source, target, normals] = load_frames(source_name, target_name)
affix = '00000000';
% Load normals of the source, filter and normalize w.r.t. the origin.
normals = readPcd(strcat(affix, source_name, '_normal.pcd'));
normals = normals(:, 1:3);
nan_inds = find(isnan(sum(normals, 2)) == 1);
normals(nan_inds, :) = [];
normals = normals';

% Load data.
source = readPcd(strcat(affix, source_name, '.pcd'));
source = source(:, 1:3);
source(nan_inds, :) = [];
far_inds = find(source(:, 3) > 2 == 1);
source(far_inds, :) = [];
normals(:, far_inds) = [];
source = source';
normals = normals - source;

target = readPcd(strcat(affix, target_name, '.pcd'));
target = target(:, 1:3);
target(target(:, 3) > 2, :) = [];
target = target';
end