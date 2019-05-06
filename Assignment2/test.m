clear all;
close all;
addpath('Utils/');
addpath('Utils/bk_ver/')
frame1 = read_frame(1);
frame2 = read_frame(2);
[f1,f2]=keypoint_matching(frame1, frame2, 12);
p1 = f1(1:2, :);
p1 = [p1; ones(1, size(p1, 2))];
p2 = f2(1:2, :);
p2 = [p2; ones(1, size(p2, 2))];
F_1 = eight_point(p1, p2);
F_2 = eight_point_normalized(p1, p2);
F_3 = eight_point_normalized_RANSAC(p1, p2);


figure; 
subplot(121);
imshow(frame1); 
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(p1(1, :), p1(2, :),'go')
epiLines = epipolarLine(F_3', p2(1:2, :)');
points = lineToBorderPoints(epiLines, size(frame1));
line(points(:, [1, 3])', points(:, [2, 4])');

subplot(122); 
imshow(frame2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(p2(1, :), p2(2, :),'go')
epiLines = epipolarLine(F_3, p1(1:2, :)');
points = lineToBorderPoints(epiLines, size(frame2));
line(points(:, [1, 3])', points(:, [2, 4])');
truesize;
