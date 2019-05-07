function [M,S]=factorization(D)
% Normalize the point coordinates 
for row = 1:size(D, 1)
    D(row, :) = D(row, :) - mean(D(row, :));
end
% ApplySVD
[U, W, V] = svd(D);
U = U(:,1:3);
V = V(:,1:3);
W = W(1:3,1:3);
% Calculate M and S matrices
M = U;
S = W * V';

% calculate L from M * L * M' = I
L = pinv(M) * eye(size(M, 1)) * pinv(M');

% calculate C using Cholesky factorization
C = chol(L,'lower');

% tune M and S
M = M*C;
S = pinv(C)*S;
end