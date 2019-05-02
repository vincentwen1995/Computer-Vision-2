function PVM = readPVM()
fileID = fopen('PointViewMatrix.txt', 'r');
PVM = fscanf(fileID, '%f', [215 202]);
PVM = PVM';
fclose(fileID);
end