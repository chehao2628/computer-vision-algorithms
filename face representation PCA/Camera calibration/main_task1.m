%%
close all;
clear all;
clc;

path = 'stereo2012b.jpg';
load data6b; % load data from mat format file
img = imread(path); % load image
P = calibrate(img, XYZ, uv); % Use calibrate to get camera calibration matrix P

% q3 List the 3x4 camera calibration matrix C
disp('Camera calibration matrix is: ');
disp(P);

% q4 Decompose the C matrix into K, R, t
[K, R, t] = vgg_KR_from_P(P);
disp('K is: ');
disp(K);
disp('R is: ');
disp(R);
disp('t is: ');
disp(t);

% q5
% Get focal length
alpha = K(1,1);
beta = K(2,2);
gama = K(1,2);
thelta = acot(-gama/alpha);
fx = alpha;
fy = beta*sin(thelta);

disp('fx is: ');
disp(num2str(fx));
disp('fy is: ');
disp(num2str(fy));

thetaX = atan2(R(3,2),R(3,3));
thetaY = atan2(-R(3,1),sqrt(R(3,2)^2+R(3,3)^2));
thetaZ = atan2(R(2,1),R(1,1));


