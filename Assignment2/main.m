close all;clc;clear all;
addpath('Utils/');
%% Prepare the data
% PVM = readPVM();
% [m,n] = size(PVM);
% p1 = [PVM(1:2,:);ones(1,n)];
% p2 = [PVM(3:4,:);ones(1,n)];
frame1 = read_frame(1);
frame2 = read_frame(2);
[f1,f2]=keypoint_matching(frame1, frame2);
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
Iterations = 20000;
threshold = 1e-3;
[F_3,Inliners] = RANSAC(p1,p2,Iterations,threshold);
display(threshold);
num_inliners=sum(Inliners);
display(num_inliners);
display(F_3);

%% Draw the epipolar lines
disp('Drawing the epipolar lines...');
figure(1)
subplot(1,3,1);
imshow(frame1);
hold on;
draw_epipolar_line(F_1,f1);
title('eight-point algorithm')
subplot(1,3,2);
imshow(frame1);
hold on;
draw_epipolar_line(F_2,f1);
title('normalized eight-point')
subplot(1,3,3);
imshow(frame1);
hold on;
draw_epipolar_line(F_3,f1);
title('RANSAC');
