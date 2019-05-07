function [PVM]=chaining()
[m1,m2]= get_matching(1,2);
PVM=[m1;m2];
for index=2:48
prev_PVM = PVM(end-1:end,:);
[m1,m2] = get_matching(index,index+1);
new_PVM = zeros(size(prev_PVM));
for i=1:size(m1,2)
    unique = true;
    for j=1:size(prev_PVM,2)
        if m1(:,i) == prev_PVM(:,j)
            new_PVM(:,j)=m2(:,i);
            unique = false;
        end
    end
    if unique
        PVM = [PVM zeros(size(PVM,1),1)];
        new_PVM=[new_PVM m2(:,i)];
    end
end
PVM=[PVM;new_PVM];
fprintf('Frame:%d of 49 \t PVM Size:%4d*%4d \t Inliers:%d\n',index+1,size(PVM,1),size(PVM,2),size(m1,2));
end

end
function [m1,m2]= get_matching(index1,index2)
frame1 = read_frame(index1);
frame2 = read_frame(index2);
[f1,f2]=keypoint_matching(frame1, frame2,1);
p1 = [f1(1:2,:);ones(1,size(f1,2))];
p2 = [f2(1:2,:);ones(1,size(f2,2))];
[~,Inliners] = RANSAC(p1,p2);
m1 = p1(1:2,Inliners);
m2 = p2(1:2,Inliners);
end
