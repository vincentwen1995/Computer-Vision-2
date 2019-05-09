function [M,S]=factorization(D, option)
if nargin == 1
    option = '';
end
% Normalize the point coordinates.
centroids = mean(D, 2);
D = D - centroids;
% Apply SVD to obtain U, W, V and enforce rank of 3.
[U, W, V] = svd(D);
U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);
% Compute M and S.
M = U * W.^0.5;
S = W.^0.5 * V';
if strcmp(option,  'affine_ambiguity')
    % Compute L from M * L * M' = Id, with d = 1
    L = pinv(M) * eye(size(M, 1)) * pinv(M');
    % Compute C from L by Cholesky decomposition: L = C * C'.
    C = chol(L,'lower');
    % Update M and S.
    M = M*C;
    S = pinv(C)*S;
end
end