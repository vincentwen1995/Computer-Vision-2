% run('/Users/robbie/VLFEATROOT/toolbox/vl_setup')
clc;clear all;close all;
addpath('Utils/');
warning('off','all')
%% Prepare the data
% PVM = readPVM();
% [m,n] = size(PVM);
% p1 = [PVM(1:2,:);ones(1,n)];
% p2 = [PVM(3:4,:);ones(1,n)];
frame_num1 = 1;
frame_num2 = 49;
frame1 = read_frame(frame_num1);
frame2 = read_frame(frame_num2);
[f1,f2]=keypoint_matching(frame1, frame2,8);
p1 = [f1(1:2,:);ones(1,size(f1,2))];
p2 = [f2(1:2,:);ones(1,size(f2,2))];

figure()
imshow([frame1 frame2])
hold on
fa = f1;
fb = f2;
h1 = vl_plotframe(fa);
set(h1,'color','y','linewidth',3);
fb(1,:) = fb(1,:) + size(frame1, 2);
h2 = vl_plotframe(fb);
set(h2,'color','y','linewidth',3);
xa = fa(1, :) ;
xb = fb(1, :) ;
ya = fa(2, :) ;
yb = fb(2, :) ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 2) ;
hold off
saveas(gca, 'results/matchings.eps', 'epsc')

%% 3.1 Eight-point Algorithm
disp('3.1 Eight-point Algorithm');
F_1=eight_point(p1,p2);
disp(F_1);

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
disp(mx_hat);
disp(my_hat);
disp(d_hat);

%% 3.2.2 Find a fundamental matrix:
disp('3.2.2 Find a fundamental matrix');
F_prime = eight_point(p_hat1,p_hat2);
disp(F_prime);

%% 3.2.3 Denormalization:
disp('3.2.3 Denormalization')
F_2 = T2'*F_prime*T1;
disp(F_2);

%% 3.3 Normalized Eight-point Algorithm with RANSAC
disp('3.3 Normalized Eight-point Algorithm with RANSAC');
Iterations = 10000;
threshold = 1;
[F_3,inliers] = RANSAC(p1,p2,Iterations,threshold);
disp(threshold);
num_inliers=sum(inliers);
disp(num_inliers);
disp(F_3);

%% Draw the epipolar lines
disp('Drawing the epipolar lines...')
figure()
subplot(3,2,1)
imshow(frame1)
hold on
draw_epipolar_line(F_1',f2)
h1 = vl_plotframe(f1) ;
set(h1,'color','y','linewidth',1) ;
hold off
title(sprintf('Eight-point Frame %d', frame_num1))
subplot(3,2,2)
imshow(frame2)
hold on
draw_epipolar_line(F_1,f1)
h2 = vl_plotframe(f2) ;
set(h2,'color','y','linewidth',1) ;
hold off
title(sprintf('Eight-point Frame %d', frame_num2))
subplot(3,2,3)
imshow(frame1)
hold on
draw_epipolar_line(F_2',f2)
h1 = vl_plotframe(f1) ;
set(h1,'color','y','linewidth',1) ;
hold off
title(sprintf('Normalized Eight-point Frame %d', frame_num1))
subplot(3,2,4)
imshow(frame2)
hold on
draw_epipolar_line(F_2,f1)
h2 = vl_plotframe(f2) ;
set(h2,'color','y','linewidth',1) ;
hold off
title(sprintf('Normalized Eight-point Frame %d', frame_num2))
subplot(3,2,5)
imshow(frame1)
hold on;
draw_epipolar_line(F_3',f2)
h1 = vl_plotframe(f1) ;
set(h1,'color','y','linewidth',1) ;
hold off
title(sprintf('RANSAC Frame %d', frame_num1))
subplot(3,2,6)
imshow(frame2)
hold on
draw_epipolar_line(F_3,f1)
h2 = vl_plotframe(f2) ;
set(h2,'color','y','linewidth',1) ;
hold off
title(sprintf('RANSAC Frame %d', frame_num2))
saveas(gca, 'results/epipolar.eps', 'epsc')

%% 4 Chaining 
disp('4 Chaining');
if isfile('PVM_2.mat') 
    disp('Loading the Point View Matrix...');
    load('PVM_2.mat');
    PVM_2 = PVM;
    load('PVM_3.mat');
    PVM_3 = PVM;
    load('PVM_4.mat');
    PVM_4 = PVM;
else
    disp('Computing the Point View Matrix...');
    disp('Size of Image Set:2');
    PVM = chaining(2);
    save('PVM_2.mat','PVM');
    PVM_2 = PVM;
    disp('Size of Image Set:3');
    PVM = chaining(3);
    save('PVM_3.mat','PVM');
    PVM_3 = PVM;
    disp('Size of Image Set:4');
    PVM = chaining(4);
    save('PVM_4.mat','PVM');
    PVM_4 = PVM;
end
% Show PVM with different size of image set.
figure();
subplot(2,2,1)
imagesc(PVM_2)
xlabel('Columns')
ylabel('Rows')
title('2 consecutive images')
subplot(2,2,2)
imagesc(PVM_3)
xlabel('Columns')
ylabel('Rows')
title('3 consecutive images')
subplot(2,2,3)
imagesc(PVM_4)
xlabel('Columns')
ylabel('Rows')
title('4 consecutive images')
subplot(2,2,4)
imagesc(readPVM())
xlabel('Columns')
ylabel('Rows')
title('PointViewMatrix.txt')
saveas(gca, 'results/step4.eps', 'epsc')
%% Structure from Motion
disp('5 Structure from Motion')
D_2 = get_dense_PVM(PVM_2);
plot_dense_block(D_2,true);
D_4 = get_dense_PVM(PVM_4);
plot_dense_block(D_4,false); 
D = readPVM();
plot_dense_block(D,true);