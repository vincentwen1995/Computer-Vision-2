function [dense_PVM]=get_dense_PVM(PVM)
    dense_PVM=[];
    for i=1:size(PVM,2)
        column = PVM(:,i);
        if min(column)>0
            dense_PVM =[dense_PVM column];
        end
    end     
end