clear;clc;close all
addpath('SupplementalCode')
[source, target, normals] = load_frames('00', '30');

%% Evaluate noise tolerance 
[~,~,stats]=ICP_variants(source,target,'normal', normals);
rms_pure=stats.rms;
% Define a simple noise
noise=normrnd(0,0.01,size(source));
[~,~,stats]=ICP_variants(source+noise,target,'normal', normals);
rms_noise=stats.rms;
% [~,~,stats]=ICP_variants(source,target,"uniform");
% rms_uniform=stats.rms;
% [~,~,stats]=ICP_variants(source,target,"uniform");
% rms_random=stats.rms;
% [~,~,stats]=ICP_variants(source,target,"normal");
% rms_uniform=stats.rms;
close all;
hold on;
plot(rms_pure);
plot(rms_noise);
xlabel("Iterations");
ylabel("RMS")
legend('without noise','with noise')
hold off


