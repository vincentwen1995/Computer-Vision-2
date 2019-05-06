function [distance]=sampson_distance(points1,points2,F)
numerator = (points2' * F * points1).^2;
fp1 = F * points1;
fp2 = F' * points2;
donominator = sum(fp1(1:2,:).^2) + sum(fp2(1:2,:).^2);
distance = diag(numerator ./ donominator);
end