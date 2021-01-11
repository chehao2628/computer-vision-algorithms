%%
function [x,y] = harris(bw)
% This function implement Harris Corner Detect algorithm to finds the 
% coordinates of corners of image.
% Input: bw     a Grayscale image or a matrix
% return: [x,y]     the N corner points as an Nx2 matrix of x and y coordinates.

sigma = 1; thresh = 0.01; % the threshold 0.01 is for normalised images; 
% if pixels are in [0,255] the corresponding threshold is 0.01*255^4.

% Derivative masks
dx = [-1 0 1;-1 0 1; -1 0 1];
dy = dx'; % dx is the transpose matrix of dy
% compute x and y derivatives of image
Ix = conv2(bw,dx,'same');
Iy = conv2(bw,dy,'same'); 

% Create a Gaussian filter with (3*sigma)*2+1 kernel size.The kernel size
% is at least 1.
g = fspecial('gaussian',max(1,fix(3*sigma)*2+1),sigma);
Ix2 = conv2(Ix.^2,g,'same'); % x and x
Iy2 = conv2(Iy.^2,g,'same'); % y and y
Ixy = conv2(Ix.*Iy,g,'same'); % x and y

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task: Compute the Harris Cornerness                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to Lecture 06 p108, Harris Cornerness can be calculated as 
% R = detM - k(traceM)^2. Where M = [Ix^2 IxIy;IxIy Iy^2]; k = 0.01 to 0.1
[h,w] = size(bw); % get the height and width of input
% create a matrix which can record Measure of corner response/Harris value
R = zeros(h,w); 
Rmax = 0; % rcord the maximum of value in generating R
k = 0.06; % k is a empirical constant. Emirically k is in [0.01, 0.1].
% this Loop compute M matrix for each image window
for i = 1:h 
    for j = 1:w 
        % get second order moments (or auto correlation ) matrix of gradients
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
        % calculate Measure of corner response
        R(i,j) = det(M)-k*(trace(M))^2; 
    end
end
Rmax = max(max(R)); % Get the maximum of R

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task: Perform non-maximum suppression and             %
%       thresholding, return the N corner points        %
%       as an Nx2 matrix of x and y coordinates         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cornerPosition = zeros(h,w); % record position of points from image
% build Non-Maximal Suppression
for i = 3:h-1 
    for j = 3:w-1
        % Thresholding
        if R(i,j) > thresh * Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1)
            if R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
                cornerPosition(i,j) = 1; % mark the point
            end
        end
    end
end
[x, y] = find(cornerPosition == 1);
end
