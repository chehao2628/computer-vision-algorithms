%%
% Pick 6 corresponding coplanar points
%path = 'Left.jpg';
%img = imread(path);
%display('click mouse for 6 features...')
%imshow(img);
%hold on;
%[u,v] = ginput(6);
%plot(u,v,'ro');
%uv = [u,v];
%save left.mat uv;

% Load data
load('left.mat', 'uv')
u2Trans = uv(:,1);
v2Trans = uv(:,2);
load('right.mat', 'uv')
uBase = uv(:,1);
vBase = uv(:,2);

% Display the two images and the location of six pairs of selected points.
img1 = imread('Left.jpg');
subplot(1,3,1);
imshow(img1);
title('2.1 Left Image');
hold;
plot(u2Trans,v2Trans,'ro');
img2 = imread('Right.jpg');
subplot(1,3,2);
imshow(img2,[]);
title('2.2 Right Image');
hold;
plot(uBase,vBase,'ro');

% homography
% H = homography(u2Trans, v2Trans, uBase, vBase);
H = homography(uBase, vBase, u2Trans, v2Trans);
disp('matrix H is:');
disp(H);

tform = projective2d(H');
I_trans = imwarp(img1,tform);
subplot(1,3,3);
imshow(I_trans);
title('2.3 Wraped Left Image');