% Task-3: Basic Image I/O
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.
% a. Read this face image from its JPG file, and resize the image to 
% 768 x 512 in columns x rows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread('Lenna.png');% Read the face image
img = imresize(img, [512,768]);
subplot(3,4,1);
imshow(img); 
title('a1. 512x768 resized image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% b. Convert the colour image into three grayscale channels, i.e., R, G, B 
% images, and display each of the three channel grayscale images separately
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
subplot(3,4,2)
imshow(R); 
title('b1. R Channel Gray Image');
subplot(3,4,3);
imshow(G); 
title('b2. G Channel Gray Image');
subplot(3,4,4);
imshow(B);
title('b3. B Channel Gray Image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c. Compute the histograms for each of the grayscale images, and display 
% the 3 histograms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,4,5);
imhist(R);
title('c1. R Channel Histogram');
ylabel('Pixel Counts');
subplot(3,4,6);
imhist(G);
title('c2. G Channel Histogram');
ylabel('Pixel Counts');
subplot(3,4,7);
imhist(B);
title('c3. B Channel Histogram');
ylabel('Pixel Counts');
% saveas(gcf,sprintf('HIS%d.png',i)); % save histogram image 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d. Apply histogram equalisation to the resized image and its three 
% grayscale channels, and then display the 4 histogram equalization image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgEq = histeq(img); % Apply histogram equalisation
imgEqR = histeq(R);
imgEqG = histeq(G);
imgEqB = histeq(B);

% Display the 4 histogram equalization image
subplot(3,4,8);
imshow(imgEq);
title('d1. resized image Histeq');
subplot(3,4,9);
imshow(imgEqR);
title('d2. R Channel Histeq');
subplot(3,4,10);
imshow(imgEqG);
title('d3. G Channel Histeq');
subplot(3,4,11);
imshow(imgEqB);
title('d4. B Channel Histeq');

%imwrite(img,'a.png');
%imwrite(R,'b.1.png');
%imwrite(G,'b.2.png');
%imwrite(B,'b.3.png');
%imwrite(imgEq,'d.1.png');
%imwrite(imgEqR,'d.2.png');
%imwrite(imgEqG,'d.3.png');
%imwrite(imgEqB,'d.4.png');