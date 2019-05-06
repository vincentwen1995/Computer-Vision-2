function F = eight_point_normalized_RANSAC(pts1, pts2)
    % pts1: [3, n] corresponding interesting points in image1.
    % pts2: [3, n] corresponding interesting points in image2.
    % Normalization.
    n = size(pts1, 2);
    m_x1 = mean(pts1(1, :));
    m_y1 = mean(pts1(2, :));
    d_1 = mean(((pts1(1, :) - m_x1).^2 + (pts1(2, :) - m_y1).^2).^0.5);
    T_1 = [sqrt(2) / d_1 0 -m_x1 * sqrt(2) / d_1; 0 sqrt(2) / d_1 -m_y1 * sqrt(2) / d_1; 0 0 1];
    pts1_hat = T_1 * pts1;
    m_x2 = mean(pts2(1, :));
    m_y2 = mean(pts2(2, :));
    d_2 = mean(((pts2(1, :) - m_x2).^2 + (pts2(2, :) - m_y2).^2).^0.5);
    T_2 = [sqrt(2) / d_2 0 -m_x2 * sqrt(2) / d_2; 0 sqrt(2) / d_2 -m_y2 * sqrt(2) / d_2; 0 0 1];
    pts2_hat = T_2 * pts2;    
    % RANSAC
    threshold = 1e-3;
    reps = 100;
    num_inliers = 0;    
    for i=1:reps
        % Randomly pick 8 points for computation.
        p_inds = randperm(n, 8);
        other_inds = setdiff(1:n, p_inds);
        % Estimate F_hat using the 8 points.
        F_hat = eight_point(pts1_hat(:, p_inds), pts2_hat(:, p_inds));
        % Compute the Sampson distance for the other correspondences.
        p = pts1_hat(:, other_inds);
        p_prime = pts2_hat(:, other_inds);
        nom = (p_prime' * F_hat * p).^2;
        denom1 = (F_hat * p).^2;        
        denom2 = (F_hat' * p_prime).^2;
        d = diag(nom)' ./ (denom1(1, :) + denom1(2, :) + denom2(1, :) + denom2(2, :));        
        % Check the inliers and record the best inliers;
        inliers_inds = min(d, threshold) ~= threshold;
        inliers = p(:, inliers_inds);
        inliers_prime = p_prime(:, inliers_inds);
        if size(inliers, 2) > num_inliers
            best_inliers = inliers;
            best_inliers_prime = inliers_prime;
            num_inliers = size(inliers, 2);
        end
    end
    % Compute F_hat with eight-point algorithm.
    F_hat = eight_point(best_inliers, best_inliers_prime);
    % Denormalize.
    F = T_2' * F_hat * T_1;    
end