%%
% read two images
img1 = imread('mandm.png');
img2 = imread('peppers.png');
img1_info = imfinfo('mandm.png'); % BitDepth:24
img2_info = imfinfo('peppers.png'); % BitDepth: 48
% convert bit of mandm_im from 48 to 24
img2 = uint8(double(img2)/65535*255);
k1 = 7; % set the number of cluster points
k2 = 7; % set the number of cluster points

new_img1 = segmentImg(img1,k1);
new_img2 = segmentImg(img2,k2);
subplot(1,2,1);
imshow(new_img1); % show segmented image
title('2.1 mandm with coordinates');

subplot(1,2,2);
imshow(new_img2); % show segmented image
title('2.2 peppers with coordinates');

function new_img = segmentImg(img, k)
% imshow(mandm_im);
% Elements in data are 5-D vector points.
[m, n, p] = size(img);

% Get first 3 lab data that are (1) L? - lightness of the color; 
%(2) a? - the color position between red and green; 
%(3) b? - the position between yellow and blue;
lab = rgb2lab(img);
% Add pixel coordinates
% lab1 = reshape(double(lab1), m*n, p);
data = zeros(m,n,5); % Intilize a 5D matrix
for r = 1:m
    for c = 1:n
        % Normlize coordinates numbers
        row = (r/m - 0.5) * 100;
        col = (c/m - 0.5) * 100;
        data(r,c,:) = [lab(r,c,1),lab(r,c,2),lab(r,c,3), row, col];
    end
end

%data = lab; % Set no pixel coordinates inforamtion

clusters = my_kmeans_plus(data, k);

% colours = ['b','g','r','c','m','y','k','w'];
co = 1;
new_img = zeros(m,n,3);
for p = 1:k
    for i = 1:size(clusters{p},1)
         xy= clusters{p}(i,:);
         new_img(xy(1),xy(2),1) = 20*co;
         new_img(xy(1),xy(2),2) = 20*co;
         new_img(xy(1),xy(2),3) = 20*co;
    end
    co = co+1;
end
new_img = uint8(new_img);
end
         

