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
else
    disp('Computing the Point View Matrix...');
    PVM = chaining();
    save('PVM_2.mat','PVM');
end

%% Structure from Motion
disp('5 Structure from Motion')
% Show PVM with different size of image set.
if isfile('PVM_2.mat')
    load('PVM_2.mat');
    PVM_2 = PVM;
else
    PVM_2 = chaining();
end

if isfile('PVM_3.mat')
    load('PVM_3.mat');
    PVM_3 = PVM;
else
    PVM_3 = chaining(3);
end

if isfile('PVM_4.mat')    
    load('PVM_4.mat');
    PVM_4 = PVM;
else
    PVM_4 = chaining(4);
end

figure();
subplot(3,1,1)
imshow(PVM_2)
title('2 consecutive images')
subplot(3,1,2)
imshow(PVM_3)
title('3 consecutive images')
subplot(3,1,3)
imshow(PVM_4)
title('4 consecutive images')
saveas(gca, 'results/step4.eps', 'epsc')

method = 'PVM'; % 'dense', 'step4', 'PVM'
sub_method = ''; % '3', '4' ...
option = ''; % '', 'affine_ambiguity'
switch method
    case 'dense'
        % Select a dense block from the point-view matrix
        D = get_dense_PVM(PVM_2);        

    case 'step4'
        % Use the method described in step 4.
        if strcmp(sub_method, '3')
            D = get_dense_PVM(PVM_3);
        else
            D = get_dense_PVM(PVM_4);
        end
        
    case 'PVM'
        % Use the provided PointViewMatrix.txt.
        D= readPVM();        
end
fprintf("Size of dense block:%d*%d\n",size(D));
[M,S]=factorization(D, option);

% Plot the keypoints in frame1 used for reconstruction.
figure()
imshow(read_frame(1))
hold on
scatter(D(1,:),D(2,:), 'rx')
hold off

% % Plot the motion (camera positions).
% figure()
% c = [ones(1, size(M, 1)); linspace(0, 1, size(M,1)); ones(1, size(M, 1))]';
% scatter3(M(:, 1), M(:, 2), M(:, 3), [], c, '.')
% % plot3(M(:, 1), M(:, 2), -M(:, 3), '.')

% Plot the shape (3D points).
figure()
scatter3(S(1, :), S(2, :), S(3, :), 'r.')
view(-15, 15)
saveas(gca, strcat('results/', method, '_', sub_method, '_',option, '_','shape.eps'), 'epsc')
% Plot the surface of the 3D points.
figure()
tri = delaunay(S(1, :), S(2, :));
trimesh(tri, S(1, :), S(2, :), S(3, :));
hold on
scatter3(S(1, :), S(2, :), S(3, :), 'r.')
view(-15, 15)
hold off
saveas(gca, strcat('results/', method, '_', sub_method, '_',option, '_', 'shape_surface.eps'), 'epsc')


