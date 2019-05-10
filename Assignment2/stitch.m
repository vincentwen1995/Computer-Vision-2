function S = stitch(S, D, option)
if nargin == 2
    option = '';
end
[~, S_new] = factorization(D, option);
[~, S, ~] = procrustes(S_new, S);
end