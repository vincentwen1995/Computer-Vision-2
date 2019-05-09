function [F,Inliers]=RANSAC(points1,points2,iterations,threshold)
if nargin == 3
   threshold=1;
end
if nargin == 2
   threshold=1;
   iterations=100;
end
max_count=0;
for i = 1:iterations
    sel = randperm(size(points1,2),8);
    p1 = points1(:,sel);
    p2 = points2(:,sel);
    F_p = normalized_eight_point(p1,p2);
    distance = sampson_distance(points1,points2,F_p); 
    count = sum(distance <= threshold);
    if count> max_count
        max_count = count;
        Inliers = distance <= threshold;
        F = F_p;
    end
end
end