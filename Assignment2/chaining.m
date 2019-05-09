function [PVM]=chaining(img_set_size)
if nargin == 0
    img_set_size=2;
end
[m1,m2]= get_matching_points(1,2);
PVM=[m1;m2];
for index=3:49
    if index>img_set_size
        new_PVM = zeros(2,size(PVM,2));
        for n = 1:img_set_size-1
            prev_indices = size(PVM,1)-2*n+1;
            prev_PVM = PVM(prev_indices:prev_indices+1,:);
            [m1,m2] = get_matching_points(index-n,index);
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
        end
    else
        prev_PVM = PVM(end-1:end,:);
        [m1,m2] = get_matching_points(index-1,index);
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
    end
    PVM=[PVM;new_PVM];
    fprintf('Frame:%2d of 49 \t PVM Size:%4d*%4d \n',index,size(PVM,1),size(PVM,2));
end
end





