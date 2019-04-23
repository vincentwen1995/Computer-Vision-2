function [R, t, stats] = ICP_variants(source, target, option, supplements)
if nargin == 3
    supplements = 0;
end
switch option
    case 'all'
        [R, t, stats] = ICP(source, target);
    case 'uniform'
        sample_rate = supplements;        
        n = size(source, 2);
        k = round(n / sample_rate);
        ind = randsample(n, k);
        [R, t, stats] = ICP(source(:, ind), target);
    case 'random'
        sample_rate = supplements;
        [R, t, stats] = ICP(source, target, true, sample_rate);
    case 'normal'
        normal = supplements;
        

end