clear all
close all

load('source.mat')
load('target.mat')
[R, t] = ICP(source, target);
tr = bsxfun(@plus, R * source, t);
figure
hold on
plot3(target(1, :), target(2, :), target(3, :), 'k.')
plot3(tr(1, :), tr(2, :), tr(3, :), 'r.')
hold off