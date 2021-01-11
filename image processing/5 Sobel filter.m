% Task -5: Implement your own 3x3 Sobel filter in Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You need to implement your own 3x3 Sobel filter. Again, you must not use 
% inbuilt edge detection filter. The implementation of the filter should be 
% clearly presented withyour code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgOrginal = imread('face 03 u6548236.jpg');% Read a face image
imgGray = rgb2gray(imgOrginal);
% The following sobel kernel created REFER to the matlab source code fspecial.m
% and ENGN6548 Week3_Lec05 p75.
horizontal_sobel_kernel = [1 2 1;0 0 0;-1 -2 -1]; 
vertical_sobel_kernel = horizontal_sobel_kernel';
outim = my_Sobel_filter(double(imgGray), horizontal_sobel_kernel);

subplot(1,3,1);
imshow(imgGray,[])
title('1 Before Sobel Filtering');

% Test it on your face Images (we suggest to convert it to gray-scale)
subplot(1,3,2);
imshow(outim,[]);
title('2 After Sobel Filtering(my sobel filter)');

% compare your result with inbuilt Sobel edge detection function
subplot(1,3,3);

% following three lines code refer to: 
% https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html
[~,threshold] = edge(imgGray,'sobel');
fudge = 0.5;
outim = edge(imgGray,'sobel',threshold * fudge);
imshow(outim);
title('3 Inbuilt Sobel Edge Detection Function');

function output_image = my_Sobel_filter(image, sobel_kernel3)
% performs a 3x3 Sobel filtering
% input: image, my 5x5 sobelKernel
% output: output_image

% Assume border shape = ¡®same¡¯: output size is same as h
border_image = zeros(size(image,1)+2,size(image,2)+2); % Intilize a 0 border image
output_image = zeros(size(image,1),size(image,2)); % Intilize a new image for receive smoothed image
for rowH = 1 : (size(image,1))
    for colH = 1 : (size(image,2))
        border_image(rowH+1,colH+1) = image(rowH,colH);
    end
end
% This part refer to the equation shows in pdf of Week3_Lec05.
% Get the sum of h[k,l]*g[m+k,n+l]
for rowH = 1 : (size(image,1))
    for colH = 1 : (size(image,2))
        h = border_image(rowH:rowH+2, colH:colH+2);
        filterSum1 = h.*sobel_kernel3; 
        filterSum2 = h.*sobel_kernel3'; 
        filterSum1 = sum(sum(filterSum1));
        filterSum2 = sum(sum(filterSum2));
        filterSum = (filterSum1+filterSum2)/2;
        if filterSum>255
            filterSum = 255;
        elseif filterSum<0
            filterSum=0;
        end
        output_image(rowH,colH) = filterSum; % notice the rotation
        % output_image(rowH,colH) = filterSum % this can makes the image be
        % black, not gray like
    end
end
end
