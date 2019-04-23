% 3.2 Merging Scenes
clear all;clc;close all;
addpath('SupplementalCode/');
addpath('fscatter3/');
rotation = eye(3, 3);
translation = zeros(3, 1);
target = load_pcd(0);
merged_frame = target;
merged_color = ones(1,size(target,2));
stepsize=1; % 2,4,10
for i = stepsize:stepsize:99
    fprintf("Iter:%d\n",i);
    % New frame as source
    source = load_pcd(i);
    [rotation, translation] = ICP(source,target,1000);
    % Reverse Transform
    merged_frame =rotation'*bsxfun(@minus, merged_frame, translation);
    merged_frame = [merged_frame source];
    merged_color = [merged_color ones(1,size(source,2))*(i+1)];
    % merged_frame as target
    target = merged_frame;
end
save('merging_scenes_2.mat','merged_frame','merged_color')
show_frame(merged_frame,merged_color);


