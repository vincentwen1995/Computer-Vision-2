function F = eight_point_normalized(pts1, pts2)
    % pts1: [3, n] corresponding interesting points in image1.
    % pts2: [3, n] corresponding interesting points in image2.
    % Normalization.
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
    % Compute F_hat with eight-point algorithm.
    F_hat = eight_point(pts1_hat, pts2_hat);
    % Denormalize.
    F = T_2' * F_hat * T_1;
end