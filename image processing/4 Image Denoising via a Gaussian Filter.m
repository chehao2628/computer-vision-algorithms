% Task-4: Image Denoising via a Gaussian Filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Read in one of your colourful face images. Crop a square image region 
% corresponding to the central facial part of the image, resize it to 256x256, 
% and save this square region to a new grayscale image. Please display the 
% two images. Make sure the pixel value range of the grayscale image is within [0, 255].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgOrginal = imread('face 02 u6548236.jpg');% Read a face image
img = imgOrginal(105:525, 310:730,:); % Get central facial part of the image
img = imresize(img, [256,256]); % Resize it to 256x256
imgGray = rgb2gray(img); % Get grayscale image
% imwrite(img,'imgGray.png'); % save this square region
subplot(2,4,1);
imshow(imgOrginal); 
title('1.1 Orginal Image');
subplot(2,4,2);
imshow(imgGray); 
title('1.2 256x256 Grayscale Image');
%imwrite(imgOrginal,'1.1.png');
%imwrite(imgGray,'1.2.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Add Gaussian noise to this new 256x256 image (Review how you generate 
% random number in Task-1). Use Gaussian noise with zero mean, and standard deviation of 15.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 0;
std = 15/255; % scale
var = std*std; % scale to range of 0 to 255
gaussianNoised = imnoise(imgGray,'gaussian',m,var);
subplot(2,4,3);
imshow(gaussianNoised); 
title('2.1 Gaussian Noised Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Display the two histograms side by side, one before adding the noise and one after adding the noise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,4,4);
imhist(imgGray); 
title('3.1 Before adding Gaussian Noised');
subplot(2,4,5);
imhist(gaussianNoised); 
title('3.2 After adding Gaussian Noised');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Implement your own Matlab function that performs a 5x5 Gaussian filtering. Your function interface is:
% my_Gauss_filter()
%       input: noisy_image, my 5x5 gausskernel
%       output: output_image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Answer:
% Please find the my_Gauss_filter Function at the end of this file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5a. Apply your Gaussian filter to the above noisy image, and display the 
% smoothed images and visually check their noise-removal effects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gauss_kernel5 = fspecial('gaussian',5,1); % 5x5 kernel, 考=1
%subplot(2,4,6);
%imshow(gaussianNoised)
%title('6.1 Before Smoothed Image');

subplot(2,4,6);
my_outim = my_Gauss_filter(double(gaussianNoised), gauss_kernel5);
imshow(my_outim, []);
title('6.1 After Smoothed ImageI(my gauss filter)');
%imwrite(my_outim,'4 5.1.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5b. One of the key parameters to choose for the task of image filtering 
% is the standard deviation of your Gaussian filter. You may need to test 
% and compare different Gaussian kernels with different standard deviations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Through compareing different standard deviations, when 考 is xxx, the 
% filter that I built makes the best performance.

% Answer:
% Gaussian filter can smooth the noised image. If the standard deviation of
% Gaussian kernel is too small, it cannot change the noised image too much.
% But if the standard deviation of Gaussian kernel is too large, the
% handled image will be 'too smooth' and looks a very blur of orginal image.
% Through tried different standard deviation (from 0.1 to 5) of Gaussian 
% kernel on filtering the image 'face 02 u6548236.jpg', the best standard 
% deviation for visually should be around 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. Compare your result with that by Matlab＊s inbuilt 5x5 Gaussian filter 
% (e.g. filter2(), imfilter() in Matlab, or conveniently cv2.GaussianBlur() 
% in Python,). Please show that the two results are nearly identical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,4,7);
% gauss_kernel5 = gauss_kernel5/sum(sum(gauss_kernel5));
matlab_outim = filter2(gauss_kernel5, double(gaussianNoised));
% matlab_outim = imfilter(gaussianNoised, gauss_kernel5);
imshow(matlab_outim,[]);
title('6.2 After Smoothed Image(matlab imfilter)');
%gauss_kernel1 = fspecial('gaussian',5,0.1); % 5x5 kernel, 考=1
%gauss_kernel2 = fspecial('gaussian',5,0.3); % 5x5 kernel, 考=1
%gauss_kernel3 = fspecial('gaussian',5,0.5); % 5x5 kernel, 考=1
%gauss_kernel4 = fspecial('gaussian',5,0.7); % 5x5 kernel, 考=1
%gauss_kernel5 = fspecial('gaussian',5,0.9); % 5x5 kernel, 考=1


function addRandImg = clip(addRandImg)
for row = 1: size(addRandImg,1)
    for col = 1:size(addRandImg,2)
        if addRandImg(row,col)<0
            addRandImg(row,col) = 0;
        elseif addRandImg(row,col)>255
            addRandImg(row,col) = 255;
        else
            addRandImg(row,col) = addRandImg(row,col);
        end
    end
end
end

function output_image = my_Gauss_filter(noisy_image, gauss_kernel5)
% performs a 5x5 Gaussian filtering
% input: noisy_image, my 5x5 gaussKernel
% output: output_image

% Assume border shape = ＆same＊: output size is same as h
border_noisy_image = zeros(size(noisy_image,1)+4,size(noisy_image,2)+4); % Intilize a 0 border noisy image
output_image = zeros(size(noisy_image,1),size(noisy_image,2)); % Intilize a new image for receive smoothed image
for rowH = 1 : (size(noisy_image,1))
    for colH = 1 : (size(noisy_image,2))
        border_noisy_image(rowH+2,colH+2) = noisy_image(rowH,colH);
    end
end
% This part refer to the equation shows in pdf of Week3_Lec05.
% Get the sum of h[k,l]*g[m+k,n+l]
for rowH = 1 : (size(noisy_image,1))
    for colH = 1 : (size(noisy_image,2))
        h = border_noisy_image(colH:colH+4, rowH:rowH+4);
        filterSum = h.*gauss_kernel5; % That equation
        filterSum = sum(sum(filterSum));
        output_image(colH,rowH) = filterSum;
    end
end
output_image = clip(output_image);
end
