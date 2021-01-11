% Task-2: Basic Coding Practice

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Load a grayscale image, and map the image to its negative image, in which the
% lightest values appear dark and vice versa. Display it side by side with its
% original version.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread('Lenna.png');
imgGray = rgb2gray(img);% Load a grayscale image
% The above image downloaded from website:
% https://images.squarespace-cdn.com/content/v1/55942f2be4b0fc1e2ed566ac/1558200322030-3FF61O9847SR6NSZVZ52/ke17ZwdGBToddI8pDm48kHH9S2ID7_bpupQnTdrPcoF7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0nQwvinDXPV4EYh2MRzm-RRB5rUELEv7EY2n0AZOrEupxpSyqbqKSgmzcCPWV5WMiQ/HWLH+crew_1.jpg?format=1500w
subplot(2,4,1);
imshow(imgGray);
title('1.1 Original Gray Image');
% map the image to its negative image
imgNeg = 255 - imgGray; % negative
subplot(2,4,2);
imshow(imgNeg);
title('1.2 Negative Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Flip the image vertically (i.e, map it to an upside down version).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgFlipVertical = flipud(imgGray);  % Vertically Flip
subplot(2,4,3);
imshow(imgFlipVertical);
title('2.1 Vertical Flipped Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Load a colour image, swap the red and blue colour channels of the input.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread('Lenna.png');  % Load a colour image
subplot(2,4,4);
imshow(img);
title('3.1 Before Swaped RB channels'); % show the loaded colour image

imgBGR = img;
imgBGR(:,:,1) = img(:,:,3);
imgBGR(:,:,3) = img(:,:,1);
subplot(2,4,5);
imshow(imgBGR); % show the RB channels Swaped colour image
title('3.2 After Swaped RB channels');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Average the input image with its vertically flipped image (use typecasting).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgGray_double = double(imgGray); % typecasting
imgFlipVertical_double = double(imgFlipVertical);
imgAve = (imgGray_double + imgFlipVertical_double)/2;
imgAve  = uint8(imgAve); % typecasting
subplot(2,4,6);
imshow(imgAve);
title('4.1 Average Input and Vertically Flipped');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Add a random value between [0,255] to every pixel in the grayscale image, then
% clip the new image to have a minimum value of 0 and a maximum value of 255.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
randomArray = randi(256,size(imgGray))-1; % random value between [0,255]
randomArray  = uint8(randomArray);
imgGray  = uint8(imgGray);
addRandImg = imgGray + randomArray;
% Clip the new image to have a minimum value of 0 and a maximum value of 255.
% Not found the internal function for clip in matlab, write it myself
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
subplot(2,4,7);
imshow(addRandImg);
title('5.1 Noised and Clipped Image');

% imwrite(imgGray,'1.1.png');
% imwrite(imgNeg,'1.2.png');
% imwrite(imgFlipVertical,'2.1.png');
% imwrite(img,'3.1.png');
% imwrite(imgBGR,'3.2.png');
% imwrite(imgAve,'4.1.png');
% imwrite(addRandImg,'5.1.png');