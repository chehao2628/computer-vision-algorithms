%%
img1 = imread('mandm.png');
img2 = imread('peppers.png');
img1_info = imfinfo('mandm.png'); % BitDepth:24
img2_info = imfinfo('peppers.png'); % BitDepth: 48
% convert bit of mandm_im from 48 to 24
img2 = uint8(double(img2)/65535*255);
k = 5;
J = imsegkmeans(img2,k);
imshow(J,[]);


