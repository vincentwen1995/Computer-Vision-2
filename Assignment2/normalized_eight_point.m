function [F] = normalized_eight_point(p1,p2)
T1 = get_norm_trans(p1);
T2 = get_norm_trans(p2);
p_hat1 = T1 * p1;
p_hat2 = T2 * p2;
F_prime = eight_point(p_hat1,p_hat2);
F = T2'*F_prime*T1;
end