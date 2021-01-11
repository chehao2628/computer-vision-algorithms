% Task-6: Image Rotation

imgOrginal = imread('Lenna.png');% Load image
img = imgOrginal(1:720, 512-360:512+360,:); % Get central facial part of the image
img = imresize(img, [512, 512]); % Resize it to 512x512
%imshow(r);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Implement your own function my_rotation() for image rotation by any given
% angle between [-90o, 90o]. Display images rotated by -90o, -45o, -15o, 45o, and
% 90o
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The equation for Image Rotation x' = [ R t ]x refer to the book: "2.1.2 of
% Computer Vision:Algorithms and Applications". In this task, only for
% rotation and no moving, so t = 0.
degree1 = -90;
rotated_img1 = my_forward_rotation(img,degree1);
degree2 = -45;
rotated_img2 = my_forward_rotation(img,degree2);
degree3 = -15;
rotated_img3 = my_forward_rotation(img,degree3);
degree4 = 45;
rotated_img4 = my_forward_rotation(img,degree4);
subplot(2,3,1);
imshow(img)
title('Orginal Image');

% Test it on your face Images
subplot(2,3,2);
imshow(rotated_img1, [])
title('1.1 Forward Rotate -90');

subplot(2,3,3);
imshow(rotated_img2, []);
title('1.2 Forward Rotate -45');

subplot(2,3,4);
imshow(rotated_img3, [])
title('1.3 Forward Rotate -15');

subplot(2,3,5);
imshow(rotated_img4, []);
title('1.4 Forward Rotate 45');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Compare forward and backward mapping and analyze their difference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
% Test on my_backward_rotation for backward rotation
degree1 = -90;
rotated_img5 = my_backward_rotation(img,degree1);
degree2 = -45;
rotated_img6 = my_backward_rotation(img,degree2);
degree3 = -15;
rotated_img7 = my_backward_rotation(img,degree3);
degree4 = 45;
rotated_img8 = my_backward_rotation(img,degree4);

subplot(2,3,1);
imshow(img)
title('Orginal Image');

% Test it on your face Images
subplot(2,3,2);
imshow(rotated_img5, [])
title('2.1 Backward Rotate -90');

subplot(2,3,3);
imshow(rotated_img6, []);
title('2.2 Backward Rotate -45');

subplot(2,3,4);
imshow(rotated_img7, [])
title('2.3 Backward Rotate -15');

subplot(2,3,5);
imshow(rotated_img8, []);
title('2.4 Backward Rotate 45');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Compare different interpolation methods and analyze their difference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
img = imgOrginal(1:720, 512-360:512+360,:); % Get central facial part of the image
img1 = imresize(img,[512,512],'nearest');
img2 = imresize(img,[512,512],'bilinear');
img3 = imresize(img,[512,512],'bicubic');  

subplot(1,2,1);
imshow(img1);
title('3.1 Interpolation by nearest');
subplot(1,2,2);
imshow(img2);
title('3.2 Interpolation by bilinear');

function [rotated_img] = my_forward_rotation(image, degree)
% Calculate image size after rotation
[row,col,o] = size(image);
% Refer to Week2-Lec03 p52, for the positive for clockwise, matrix [cosx,sinx;-sinx,cosx]
R = [cosd(degree), sind(degree); -sind(degree),cosd(degree)]; % positive for clockwise.
h = round(row*abs(cosd(degree))+col*abs(sind(degree))); % Identify the size of image
w = round(col*abs(cosd(degree))+row*abs(sind(degree)));  
rotated_img = zeros(h, w, o);
for r = 1 : size(image,1)
    for c = 1 : size(image,2)
        xy = R*[r-row/2;c-col/2]; % x' = [ R t ]x
        x = round(xy(1)+h/2);
        y = round(xy(2)+w/2);
        if(x>=1&&x<=h)&&(y>=1&&y<=w)
            rotated_img(x,y,:) = image(r,c,:);
        end
        %rotated_img(round(x(1)),round(x(2))) = image(r,c);
    end
end
rotated_img = uint8(rotated_img);
end

function [rotated_img] = my_backward_rotation(image, degree)
% Calculate image size after rotation
[row,col,o] = size(image);
% Refer to Week2-Lec03 p52, for the negitive for clockwise, transpose the
% matrix [cosx,sinx;-sinx,cosx]
R = [cosd(degree), -sind(degree); sind(degree),cosd(degree)]; % positive for clockwise.
h = round(row*abs(cosd(degree))+col*abs(sind(degree))); % Identify the size of image
w = round(col*abs(cosd(degree))+row*abs(sind(degree)));  
rotated_img = zeros(h, w, o);
for r = 1 : size(rotated_img,1)
    for c = 1 : size(rotated_img,2)
        xy = R*[r-h/2;c-w/2]; % x' = [ R t ]x
        x = round(xy(1)+row/2);
        y = round(xy(2)+col/2);
        if(x>=1&&x<=row)&&(y>=1&&y<=col)
            rotated_img(r,c,:) = image(x,y,:);
        end
        %rotated_img(round(x(1)),round(x(2))) = image(r,c);
    end
end
rotated_img = uint8(rotated_img);
end
