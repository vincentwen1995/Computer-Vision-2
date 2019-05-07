function [m1,m2]= get_matching_points(index1,index2)
    frame1 = read_frame(index1);
    frame2 = read_frame(index2);
    [f1,f2]=keypoint_matching(frame1, frame2,1);
    p1 = [f1(1:2,:);ones(1,size(f1,2))];
    p2 = [f2(1:2,:);ones(1,size(f2,2))];
    [~,Inliners] = RANSAC(p1,p2);
    m1 = p1(1:2,Inliners);
    m2 = p2(1:2,Inliners);
end