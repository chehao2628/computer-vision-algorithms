%%
% CLAB2 Task-1: Harris Corner Detector

% First image
img1 = imread('Harris_1.jpg');
imgGray1 = rgb2gray(img1);
[x,y] = harris(imgGray1);

subplot(2,4,1);
disp(size(x)); % show the corner numbers
imshow(imgGray1); % show orginal image
title('1.1 my harris funnciton result');
hold on; 
plot(y,x,'r+'); % add these corner points

subplot(2,4,2);
corners = corner(imgGray1);
imshow(imgGray1);
title('1.2 Matlab built-in funnciton result');
hold on
plot(corners(:,1), corners(:,2), 'r+');

% Second image
img2 = imread('Harris_1.pgm');
[x,y] = harris(img2);

subplot(2,4,3);
disp(size(x)); % show the corner numbers
imshow(img2); % show orginal image
title('1.3 my harris funnciton result');
hold on
plot(y,x,'r+'); % add these corner points

subplot(2,4,4);
corners = corner(img2);
imshow(img2);
title('1.4 Matlab built-in funnciton result');
hold on
plot(corners(:,1), corners(:,2), 'r+');


% Third image
img3 = imread('Harris_3.jpg');
imgGray3 = rgb2gray(img3);
[x,y] = harris(imgGray3);

subplot(2,4,5);
disp(size(x)); % show the corner numbers
imshow(imgGray3); % show orginal image
title('1.5 my harris funnciton result');
hold on
plot(y,x,'r+'); % add these corner points

subplot(2,4,6);
corners = corner(imgGray3);
imshow(imgGray3);
title('1.6 Matlab built-in funnciton result');
hold on
plot(corners(:,1), corners(:,2), 'r+');


% Fourth image
img4 = imread('Harris_4.jpg');
imgGray4 = rgb2gray(img4);
[x,y] = harris(imgGray4);

subplot(2,4,7);
disp(size(x)); % show the corner numbers
imshow(imgGray4); % show orginal image
title('1.7 my harris funnciton result');
hold on
plot(y,x,'r+'); % add these corner points

subplot(2,4,8);
corners = corner(imgGray4);
imshow(imgGray4);
title('1.8 Matlab built-in funnciton result');
hold on
plot(corners(:,1), corners(:,2), 'r+');



