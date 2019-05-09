function plot_dense_block(D,reverse)
[M,S]=factorization(D, 'affine_ambiguity');
% Plot the surface 
figure();
subplot(1,3,1);
imshow(read_frame(1));
hold on;
plot(D(1,:),D(2,:),'yo');
subplot(1,3,2);
% Plot the camera positions
if reverse
plot3(S(2, :), S(1, :), S(3, :), '.');
else
plot3(S(1, :), S(2, :), S(3, :), '.');   
end
grid on;
rotate3d on;
pbaspect([1 1 1]);
subplot(1,3,3);
if reverse
plot_trimesh(S(2, :), S(1, :), S(3, :));
else
plot_trimesh(S(1, :), S(2, :), S(3, :));  
end
grid on;
rotate3d on;
pbaspect([1 1 1]);
end