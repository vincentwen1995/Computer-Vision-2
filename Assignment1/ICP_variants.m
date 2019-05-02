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
        normals = supplements;     
        k = 1000;
        
        phi = atan2(normals(2, :), normals(1, :));
        theta = atan2(normals(3, :), sqrt(normals(1, :) .^ 2 + normals(2, :) .^ 2));
        
        bins = 500;
        [~, ~, ind_phi]= histcounts(phi, linspace(-pi, pi, bins));
        [~, ~, ind_theta] = histcounts(theta, linspace(-pi, pi, bins));
        ind = ind_phi * bins + ind_theta;
        
        [normals_distr, org_ind] = unique(ind);
        sample_ind = randsample(length(normals_distr), k);
        inds = org_ind(sample_ind);
        [R, t, stats] = ICP(source(:, inds), target);        
        
end