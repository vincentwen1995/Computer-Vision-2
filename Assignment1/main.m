clear all;clc;close all
addpath('Data/');
load('Data/source.mat')
load('Data/target.mat')
[R, t] = ICP(source, target);
tr = R*source+repmat(t,1,size(source,2));
figure
hold on
plot3(source(1,:), source(2,:), source(3,:),'.')
plot3(target(1,:), target(2,:), target(3,:),'.')
plot3(tr(1, :), tr(2, :), tr(3, :),'.')
legend('source','target','transformed');
rotate3d on
