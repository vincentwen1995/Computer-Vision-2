function [R, t, stats] = ICP(A1, A2, flag)
% ICP  Perform Iterative Closest Point algorithm to find R and t from
% A1(base) to A2(target).
% Args:
% A1 [double]: base points of shape d x N 
% A2 [double]: target points of shape d x N
% flag [bool]: flag for sampling per iteration.

% If not specified, set the Flag false.
if nargin == 2
    flag = false;
end    
% Define parameters.
n1 = size(A1, 2);
n2 = size(A2, 2);
d = size(A1, 1);
epsilon = 1e-5;
k = 1000;
% Initialize R = I, t = 0
R = eye(d);
t = zeros(d, 1);
rms = 1;
last_rms = 0;
% Initialize statistics records.
stats.rms = [];
stats.R = {};
stats.t = {};
stats.R_mag = {};
stats.t_mag = {};
stats.iter = 0;
while abs(rms - last_rms) > epsilon
    stats.iter=stats.iter+1;    
    A1_bk = A1;
    if flag         
        ind = randsample(n1, k);
        A1 = A1(:, ind);        
    end
%     [dist, phi] = pdist2(A2', A1', 'euclidean','Smallest', 1);
    % Find smallest euclidean distances from A1 to A2 and corresponding
    % mapping.
    [phi, dist] = knnsearch(A2', A1');
    
%     % Reject 10% worst matchings in terms of euclidean distance.
%     rej = 0.1;
%     [dist, sort_ind] = sort(dist);
%     keep_ind = 1:round((1 - rej) * length(sort_ind));
%     dist = dist(1 : length(keep_ind));
%     A1 = A1(:, sort_ind(keep_ind));
%     phi = phi(sort_ind(keep_ind));
    
    last_rms = rms;
    rms = sqrt(mean(dist .^ 2));
    stats.rms(end + 1) = rms;
    if(size(stats.rms,2)>100)
        break;
    end
    fprintf("Iter:%d\t RMS:%f\n",stats.iter,rms);
    A2_matched = A2(:, phi);
    % Compute centroids of A1 and A2.
    A1_bar = mean(A1, 2);
    A2_bar = mean(A2_matched, 2);
    % Compute centered A1 and A2.
    A1_centered = bsxfun(@minus, A1, A1_bar);
    A2_centered = bsxfun(@minus, A2_matched, A2_bar);
    % Compute SVD and R_tmp, t_tmp accordingly.    
    [U, ~, V] = svd(A1_centered * A2_centered');    
    diagonal = cat(2, ones(1, size(U, 2) - 1), [det(V * U')]); 
    R_tmp = V * diag(diagonal) * U';
    t_tmp = A2_bar - R_tmp * A1_bar;
    % Update A1.
    A1 = A1_bk;
    A1 = bsxfun(@plus, R_tmp * A1, t_tmp);
    % Update R and t.
    R = R_tmp * R;
    t = R_tmp * t + t_tmp;
    % Record R and t and their corresponding magnitudes.
    stats.R{end + 1} = R;
    stats.t{end + 1} = t;
    stats.R_mag{end + 1} = norm(R);
    stats.t_mag{end + 1} = norm(t);        
end
end