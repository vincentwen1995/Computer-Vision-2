function [T]= get_normarlize(points)
x = points(1,:);
y = points(2,:);
mx = mean(x,2);
my = mean(y,2);
d = mean(sqrt((x - mx).^2 + (y - my).^2), 2);
T = [sqrt(2)/d 0 -(mx*sqrt(2))/d ; 0 sqrt(2)/d -(my*sqrt(2))/d ; 0 0 1];
end