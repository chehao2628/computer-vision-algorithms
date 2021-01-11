%%
% This file used to  convert them to grayscale, and align and resize them
% to match the images in Yale-Face
Path = 'Self-Face\original'; 
Path2 = 'Self-Face\aligned';

path = strcat(Path,strcat('\self1.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(140:1255, 52:1002,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self1.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self2.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = imresize(img, [1440,1080]);
img = img(185:1315, 50:1015,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self2.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self3.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(135:1260, 50:1010,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self3.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self4.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(120:1245, 50:1010,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self4.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self5.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(140:1255, 53:1007,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self5.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self6.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(120:1245, 50:1010,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self6.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self7.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(85:1225, 46:1014,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self7.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self8.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(135:1260, 50:1010,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self8.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self9.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(135:1260, 50:1010,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self9.png'));
imwrite(img, path)
%imshow(img);

path = strcat(Path,strcat('\self10.jpg'));
img = imread(path);
% convert to grayscale
img = rgb2gray(img);
% Alignment
img = img(150:1245, 55:1005,:);
img = imresize(img, [231,195]);
path = strcat(Path2,strcat('\self10.png'));
imwrite(img, path)
%imshow(img);
