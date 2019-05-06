PVM = zeros(98,100);
for index=1:49
display(index);
frame1 = read_frame(index);
frame2 = read_frame(index+1);
[f1,f2]=keypoint_matching(frame1, frame2);
p1 = [f1(1:2,:);ones(1,size(f1,2))];
p2 = [f2(1:2,:);ones(1,size(f2,2))];
[F ,Inliners] = RANSAC(p1,p2,5000);
mp = unique(p1(1:2,Inliners)','rows')';
PVM(2*index-1:2*index,1:size(mp,2))=mp;
end