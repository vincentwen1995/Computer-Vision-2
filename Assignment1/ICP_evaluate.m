clear;clc;close all
addpath('SupplementalCode')
[source, target, normals] = load_frames('00', '30');

%% Evaluate noise tolerance 
[~,~,stats]=ICP_variants(source,target,"all");
rms_pure=stats.rms;
% Define a simple noise
noise=normrnd(0,0.01,size(source));
[~,~,stats]=ICP_variants(source+noise,target,"all");
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
title("Tolerance to noise for all the points selection")
xlabel("Iterations");
ylabel("RMS")
legend('without noise','with noise')


