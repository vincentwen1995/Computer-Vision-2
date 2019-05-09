function [dense_PVM]=get_dense_PVM(PVM,option)
if nargin==1
    option='';
end
full_dense_PVM=[];
part_dense_PVM=[];
for i=1:size(PVM,2)
    column = PVM(:,i);
    if min(column)>0
        full_dense_PVM =[full_dense_PVM column];
    elseif sum(column==0)<=20 && column(1)>0
        part_dense_PVM =[part_dense_PVM column];
    end
end
if strcmp(option,'stitching')
for view = 1:48
    view1 = full_dense_PVM(2*view-1:2*view,:)';
    view2 = full_dense_PVM(2*view+1:2*view+2,:)';
    [~,~,tr]=procrustes(view2,view1);
    source = part_dense_PVM(2*view-1:2*view,:)';
    target =  tr.b*source*tr.T+tr.c(1,:);
    line = part_dense_PVM(2*view+1,:)';
    index = find(line==0);
    part_dense_PVM(2*view+1:2*view+2,index)=target(index,:)';
end
dense_PVM=[full_dense_PVM part_dense_PVM];
else
dense_PVM = full_dense_PVM ;
end
end