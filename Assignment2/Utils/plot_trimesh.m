function plot_trimesh(x,y,z)
tri = delaunay(x, y);
trimesh(tri, x, y, z);
hold on
plot3(x, y, z, 'r.');
end