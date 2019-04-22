clear all
close all

load('source.mat')
load('target.mat')
source = source';
target = target';
[R, t] = ICP(source, target);
tr = bsxfun(@minus, R * source', t);
figure
hold on
plot3(target(:, 1), target(:, 2), target(:, 3), 'k.')
plot3(source(:, 1), source(:, 2), source(:, 3), 'b.')
plot3(tr(1, :), tr(2, :), tr(3, :), 'r.')
% plot3(tr(:, 1), tr(:, 2), tr(:, 3), 'r.')
hold off