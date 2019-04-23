function [R, t, stats] = ICP(A1,A2, Flag, sample_rate)
% ICP  Perform Iterative Closest Point algorithm to find R and t from
% A1(base) to A2(target).
% Args:
% A1 [double]: base points of shape d x N 
% A2 [double]: target points of shape d x N
% Flag [bool]: flag for sampling per iteration.

% If not specified, set the Flag false.
if nargin == 2
    Flag = false;
    sample_rate = 1;
end    
% Make backups for original point clouds.
Source = A1;
Target = A2;
% Define parameters.
n1 = size(A1, 2);
n2 = size(A2, 2);
d = size(A1, 1);
epsilon = 1e-5;
% Initialize R = I, t = 0
R = eye(d);
t = zeros(d, 1);
rms = 9999;
last_rms = 0;
stats.rms = {};
stats.R = {};
stats.t = {};
stats.R_mag = {};
stats.t_mag = {};
stats.iter = 1;
while abs(rms - last_rms) > epsilon    
    if Flag         
        k = round(n1/sample_rate);
        ind = randsample(n1, k);
        A1 = A1(:, ind);
    end
    % Find smallest euclidean distances from A1 to A2 and corresponding
    % mapping.
    [dist, phi] = pdist2(Target', A1', 'euclidean', 'Smallest', 1);    
    
    % Reject 10% worst matchings in terms of euclidean distance.
    rej = 0.1;
    [dist, sort_ind] = sort(dist);
    keep_ind = 1:round((1 - rej) * length(sort_ind));
    dist = dist(1 : length(keep_ind));
    A1 = A1(:, sort_ind(keep_ind));
    phi = phi(sort_ind(keep_ind));
    
    last_rms = rms;    
    rms = sqrt(mean(dist.^2)); 
    stats.rms{end + 1} = rms;
    A2 = Target(:, phi);
    % Compute centroids of A1 and A2.
    A1_bar =mean(A1, 2);
    A2_bar =mean(A2, 2);
    % Compute centered A1 and A2.
    C1=A1 - A1_bar;
    C2=A2 - A2_bar;
    % Compute the covariance matrix.
    S = C1 * C2';
    % Compute SVD and R_tmp, t_tmp accordingly.    
    [U,~,V] = svd(S);
    diagonal = cat(2, ones(1, size(U, 2) - 1), [det(V * U')]);    
    R_tmp = V * diag(diagonal) * U';
    t_tmp = A2_bar - R * A1_bar;
    % Update R and t.
    R = R_tmp * R;
    t = R_tmp * t + t_tmp;    
    % Record R and t and their corresponding magnitudes.
    stats.R{end + 1} = R;
    stats.t{end + 1} = t;
    stats.R_mag{end + 1} = norm(R);
    stats.t_mag{end + 1} = norm(t);    
    % Apply the latest transformation and update A1.
    A1 = R * Source + t;
    stats.iter = stats.iter + 1;
end
end

