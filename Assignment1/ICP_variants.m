function [R, t, stats] = ICP_variants(source, target, option, supplements)
if nargin == 3
    supplements = 0;
end
switch option
    case 'all'
        [R, t, stats] = ICP(source, target);
    case 'uniform'  
        n = size(source, 2);
        k = 1000;
        inds = randsample(n, k);
        [R, t, stats] = ICP(source(:, inds), target);
    case 'random'
        [R, t, stats] = ICP(source, target, true);
    case 'normal'
        n = size(source, 2);
        normals = supplements;
        neighbors = 10;
        var_threshold = 5e-5;
        k = 1000;
        inds = {};                
                
        while  length(inds) < k
            tmp_inds = randsample(n, k);
            [neighbor_inds, ~] = knnsearch(source', (source(:, tmp_inds))', 'k', neighbors);
            i = 1;
            while i < length(tmp_inds) && length(inds) < k
                tmp_normals = normals(:, neighbor_inds(i, :));
                if var(tmp_normals) > var_threshold
                    inds{end + 1} = tmp_inds(i);                    
                end
                i = i + 1;
            end            
        end
        inds = cell2mat(inds);
        [R, t, stats] = ICP(source(:, inds), target);
        
end