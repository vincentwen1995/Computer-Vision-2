function [F,Inliers]=RANSAC(points1,points2,Iterations,threshold)
if nargin == 3
   threshold=1e-3;
end
if nargin == 2
   threshold=1e-3;
   Iterations=10000;
end
Inliers=0;
for i = 1:Iterations
    sel = randperm(size(points1,2),8);
    p1 = points1(:,sel);
    p2 = points2(:,sel);
    F_p = normalized_eight_point(p1,p2);
    numerator = (points2' * F_p * points1).^2;
    fp1 = F_p * points1;
    fp2 = F_p' * points2;
    donominator = sum(fp1(1:2,:).^2) + sum(fp2(1:2,:).^2);
    distance = diag(numerator ./ donominator);
    count = sum(distance < threshold);
    if count> Inliers
        Inliers = count;
        F = F_p;
    end
end
end