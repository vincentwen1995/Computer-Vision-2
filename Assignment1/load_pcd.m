function [pcd_data]=load_pcd(index)
filepath = sprintf('Data/data/%010d.pcd',index);
pcd_data = readPcd(filepath);
pcd_data = pcd_data(:,1:3)';
pcd_data = pcd_data(:, pcd_data(3,:) < 2);
end