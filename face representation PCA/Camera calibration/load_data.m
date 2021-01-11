%%
% This class produce the corrdinates of XYZ (12 x 3) and uv(12 x 2).
% Following right-hand coordinate system.
path = 'stereo2012b.jpg';
%XYZ = [7 7 0;14 7 0;7 14 0;21 21 0;7 0 7;14 0 7;7 0 14;21 0 21;0 7 7;0 14 7;0 7 14;0 21 21];
XYZ = [7 7 0;14 21 0;7 0 7;21 0 7;0 7 7;0 21 14];
img = imread(path);
display('click mouse for 6 features...')
imshow(img);
hold on;
[u,v] = ginput(6);
plot(u,v,'ro');
uv = [u,v];
save data6b.mat XYZ uv;
