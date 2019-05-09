function plot_dense_block(D,reverse)
[M,S]=factorization(D, 'affine_ambiguity');
% Plot the points on image 
figure();
subplot(1,2,1);
imshow(read_frame(1));
hold on;
plot(D(1,:),D(2,:),'yo');
subplot(1,2,2);
% Plot the 3D points with trimesh
if reverse
plot_trimesh(S(2, :), S(1, :), S(3, :));
view(45,-70)
else
plot_trimesh(S(1, :), S(2, :), S(3, :));  
view(-45,-70)
end
grid on;
rotate3d on;
pbaspect([1 1 1]);
end