close all;
addpath('Utils/');
frame1 = read_frame(1);
frame2 = read_frame(2);
[f1,f2]=keypoint_matching(frame1, frame2, 8);
imshow(frame1);
hold on;
h1 = vl_plotframe(f1) ;
set(h1,'color','y','linewidth',3) ;