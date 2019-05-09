function draw_epipolar_line(F,points)
n = size(points,2);
for i=1:n
    line = F * [points(1,i);points(2,i);1];
    x = linspace(1,512);
    y = (-line(1)*x - line(3))/line(2);
    plot(x,y, 'linewidth',1);
end
end
