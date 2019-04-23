function [R, t] = ICP(A1,A2)
plot_mag=false;
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
epsilon = 1e-3;
rms = 100;
last_rms = 0;
count=0;
while abs(rms - last_rms) > epsilon
% Match with bruteForce
[min_dist, match] = pdist2(Target', A1', 'euclidean','Smallest', 1);
last_rms = rms;
rms = sqrt(sum(min_dist.^2) / size(min_dist,2));
count=count+1;
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
R_mag(count)=norm(R);
t_mag(count)=norm(t);
% Apply the latest transformation
A1 = R*Source+repmat(t,1,n1);
end
% Plot the magnitude
if plot_mag
subplot(2,1,1)
plot(R_mag)
title('Magnitude of R');
subplot(2,1,2)
plot(t_mag)
title('Magnitude of t');
end
end