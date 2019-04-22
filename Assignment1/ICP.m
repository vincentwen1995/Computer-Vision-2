function [R, t] = ICP(A1, A2)
% ICP  Perform Iterative Closest Point algorithm to find R and t from
% A1(base) to A2(target).
% Args:
% A1 [double]: base points of shape N x d 
% A2 [double]: target points of shape N x d

% Make backups for original point clouds.
A1_org = A1;
A2_org = A2;
% Define parameters.
epsilon = 1e-6;
n = size(A1, 1);
d = size(A1, 2);
% Initialize R and t.
R = eye(d);
t = 0;
rms = 9999;
last_rms = 0;
iter = 1;
while abs(rms - last_rms) > epsilon
    % Find smallest euclidean distances from A1 to A2 and corresponding
    % mapping.
    [dists, phi] = pdist2(A2, A1, 'euclidean','Smallest', 1);
    A2 = A2(phi, :);
    % Compute centroids of A1 and A2.
    A1c = mean(A1, 1);
    A2c = mean(A2, 1);
    % Compute centered A1 and A2.
    A1_centered = A1 - A1c;
    A2_centered = A2 - A2c;
    % Compute the covariance matrix.
    S = A1_centered' * A2_centered;
    % Compute SVD and R, t accordingly.
    [U, Sigma, V] = svd(S);
    V = V';
    diags = cat(2, ones(1, size(Sigma, 1) - 1), [det(V * U')]);
    R = V * diag(diags) * U';
    t = A1c * R - A2c;
    % Update RMS.
    last_rms = rms;
    rms = sqrt(sum(dists) / n);
    iter = iter + 1;
end
end
