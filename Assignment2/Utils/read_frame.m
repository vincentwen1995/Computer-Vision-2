function [frame] = read_frame(index)
    path = sprintf('Data/House/frame%08d.png',index);
    frame = imread(path);
end