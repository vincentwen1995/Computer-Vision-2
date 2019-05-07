clear all;
img_set_size = 4;
[m1,m2]= get_matching_points(1,2);
PVM=[m1;m2];
for index=3:49
    if index>img_set_size
        new_PVM = zeros(2,size(PVM,2));
        for n = 1:img_set_size-1
            display(index);
            display(n);
            prev_indice = size(PVM,1)-2*n+1;
            prev_PVM = PVM(prev_indice:prev_indice+1,:);
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
        PVM=[PVM;new_PVM];
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
        PVM=[PVM;new_PVM];
    end
end
