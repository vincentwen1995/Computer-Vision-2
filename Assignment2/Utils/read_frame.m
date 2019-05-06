function [frame] = read_frame(index)
    index = mod(index-1 , 49)+1;
    path = sprintf('Data/House/frame%08d.png',index);
    frame = imread(path);
end