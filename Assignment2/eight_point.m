function F = eight_point(pts1, pts2)
    % pts1: [2, n] corresponding interesting points in image1.
    % pts2: [2, n] corresponding interesting points in image2.
    n = size(pts1, 2);
    % Initialize A.    
    A = zeros(n, 9);    
    A(:, 1) = pts1(1, :) .* pts2(1, :);
    A(:, 2) = pts1(1, :) .* pts2(2, :);
    A(:, 3) = pts1(1, :);
    A(:, 4) = pts1(2, :) .* pts2(1, :);    
    A(:, 5) = pts1(2, :) .* pts2(2, :);
    A(:, 6) = pts1(2, :);
    A(:, 7) = pts2(1, :);
    A(:, 8) = pts2(2, :);
    A(:, 9) = ones(n, 1);
    % Compute F.
    [~, ~, V] = svd(A);
    F = V(:, end);
    F = reshape(F, [3, 3]);    
    % Enforce singularity of F.
    [U_f, D_f, V_f] = svd(F);
    D_f(end, end) = 0;
    F = U_f * D_f * V_f;   
end