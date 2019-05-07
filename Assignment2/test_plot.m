clc;clear all;close all;
addpath('Utils/');
%% Image Alignment 
Ia=read_frame(1);
Ib=read_frame(2);
imshow([Ia Ib]) ;
[fa,fb]=keypoint_matching(Ia,Ib,0);

% Take a random subset (with set size set to 10) 
perm=randperm(size(fa,2));
sel=perm(1:size(fa,2));

%Plot the frames
g=figure(1);
hold on;
h1 = vl_plotframe(fa(:,sel)) ;
set(h1,'color','y','linewidth',0.1) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
h2 = vl_plotframe(fb(:,sel)) ;
set(h2,'color','y','linewidth',0.1) ;
hold on;
% Connect matching pairs with lines.
xa = fa(1,sel) ;
xb = fb(1,sel) ;
ya = fa(2,sel) ;
yb = fb(2,sel) ;
hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 0.01) ;
saveas(g, 'results/back_rm_1.eps', 'epsc');

