function [R, t] = ICP2(A1,A2)
% Backup the inputs
Source = A1;
Target = A2;
% Get the sizes of the inputs
n1 = size(A1,2);
n2 = size(A2,2);
d = size(A1,1);
% Initialize R = I, t = 0
R = eye(d);
t = zeros(d,1);
% Define parameters
epsilon = 1e-6;
rms = 100;
last_rms = 0;
while abs(rms - last_rms) > epsilon
% Match with bruteForce
[min_dist, match] = pdist2(Target', A1', 'euclidean','Smallest', 1);
last_rms = rms;
rms = sqrt(sum(min_dist.^2) / size(min_dist,2));
A2=Target(:,match);
% Compute the centered vectors
A1_bar =mean(A1,2);
A2_bar =mean(A2,2);
C1=A1-A1_bar;
C2=A2-A2_bar;
% Singular value decomposition
[U,~,V] = svd(C1 * C2');
Ri = V*diag([1 1 det(U*V')])*U';
ti = A2_bar-R*A1_bar;
% Update R and t
R = Ri*R;
t = Ri*t + ti;
% Apply the latest transformation
A1 = R*Source+repmat(t,1,n1);
end
end
