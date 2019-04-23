% ICP algorithm:
function [rotation, translation] = ICP(source, target, num_sample)
% Initialize R = I, t = 0
rotation = eye(3, 3);
translation = zeros(3, 1);
rms = 1;rms_old=0;eps = 1e-5;iter=0;
while abs(rms - rms_old) > eps
    iter=iter+1;
    target = subsample(target, 'uniform', num_sample);
    % Match with bruteForce
    [min_dist, match] = pdist2(target', source', 'euclidean','Smallest', 1);
    rms_old = rms;
    rms = sqrt(sum(min_dist.^2) / size(min_dist,2));
    target_matched = target(:, match);
    % Compute the centered vectors
    source_avg = mean(source, 2);
    target_avg = mean(target_matched, 2);
    centered_source = bsxfun(@minus, source, source_avg);
    centered_target = bsxfun(@minus, target_matched, target_avg);
    % Singular value decomposition
    [U, ~, V] = svd(centered_source * centered_target');
    % Compute R and t
    R = V * diag([1 1 det(U*V')]) * U';
    t = target_avg - R * source_avg;
    source = bsxfun(@plus, R * source, t);
    % Update rotation and translation
    rotation = R * rotation;
    translation = R * translation + t;
end
end