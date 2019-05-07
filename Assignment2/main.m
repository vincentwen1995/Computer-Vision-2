% run('/Users/robbie/VLFEATROOT/toolbox/vl_setup')
clc;clear all;close all;
addpath('Utils/');
%% Prepare the data
% PVM = readPVM();
% [m,n] = size(PVM);
% p1 = [PVM(1:2,:);ones(1,n)];
% p2 = [PVM(3:4,:);ones(1,n)];
frame1 = read_frame(1);
frame2 = read_frame(30);
[f1,f2]=keypoint_matching(frame1, frame2,8);
p1 = [f1(1:2,:);ones(1,size(f1,2))];
p2 = [f2(1:2,:);ones(1,size(f2,2))];
%% 3.1 Eight-point Algorithm
disp('3.1 Eight-point Algorithm');
F_1=eight_point(p1,p2);
display(F_1);

%% 3.2.1 Normalization
disp('3.2.1 Normalization');
T1 = get_norm_trans(p1);
T2 = get_norm_trans(p2);
p_hat1 = T1 * p1;
p_hat2 = T2 * p2;
x = p_hat1(1,:);
y = p_hat1(2,:);
mx_hat = mean(x,2);
my_hat = mean(y,2);
d_hat = mean(sqrt((x - mx_hat).^2 + (y - my_hat).^2), 2);
display(mx_hat);display(my_hat);display(d_hat);

%% 3.2.2 Find a fundamental matrix:
disp('3.2.2 Find a fundamental matrix');
F_prime = eight_point(p_hat1,p_hat2);
display(F_prime);

%% 3.2.3 Denormalization:
disp('3.2.3 Denormalization')
F_2 = T2'*F_prime*T1;
display(F_2);

%% 3.3 Normalized Eight-point Algorithm with RANSAC
disp('3.3 Normalized Eight-point Algorithm with RANSAC');
Iterations = 10000;
threshold = 1e-3;
[F_3,inliers] = RANSAC(p1,p2,Iterations,threshold);
display(threshold);
num_inliers=sum(inliers);
display(num_inliers);
display(F_3);

%% Draw the epipolar lines
disp('Drawing the epipolar lines...');
subplot(3,2,1);
imshow(frame1);
hold on;
draw_epipolar_line(F_1',f2);
title('eight-point algorithm frame 1');
subplot(3,2,2);
imshow(frame2);
hold on;
draw_epipolar_line(F_1,f1);
title('eight-point algorithm frame 2');

subplot(3,2,3);
imshow(frame1);
hold on;
draw_epipolar_line(F_2',f2);
title('normalized eight-point frame 1')
subplot(3,2,4);
imshow(frame2);
hold on;
draw_epipolar_line(F_2,f1);
title('normalized eight-point frame 2')
subplot(3,2,5);
imshow(frame1);
hold on;
draw_epipolar_line(F_3',f2);
title('RANSAC frame 1');
subplot(3,2,6);
imshow(frame2);
hold on;
draw_epipolar_line(F_3,f1);
title('RANSAC frame 2');

%% 4 Chaining 
disp('4 Chaining');
if isfile('PVM.mat') 
    disp('Loading the Point View Matrix...');
    load('PVM.mat');
else
    disp('Computing the Point View Matrix...');
    PVM = chaining();
    save('PVM.mat','PVM');
end
figure();
imshow(PVM);
dense_PVM = get_dense_PVM(PVM);

