%% CLAB3 

function P = calibrate(im, XYZ, uv)
% TASK 1: CALIBRATE
%
% Function to perform camera calibration
%
% Usage:   K = calibrate(image, XYZ, uv)
%
%   Where:   image - is the image of the calibration target.
%            XYZ - is a N x 3 array of  XYZ coordinates
%                  of the calibration target points. 
%            uv  - is a N x 2 array of the image coordinates
%                  of the calibration target points.
%            K   - is the 3 x 4 camera calibration matrix (return it).
%  The variable N should be an integer greater than or equal to 6.
%
%  This function plots the uv coordinates onto the image of the calibration
%  target. Done
%
%  It also projects the XYZ coordinates back into image coordinates using
%  the calibration matrix and plots these points too as 
%  a visual check on the accuracy of the calibration process. Done
%
%  Lines from the origin to the vanishing points in the X, Y and Z
%  directions are overlaid on the image. 
%
%  The mean squared error between the positions of the uv coordinates 
%  and the projected XYZ coordinates is also reported.
%
%  The function should also report the error in satisfying the 
%  camera calibration matrix constraints.

% The algorithm follows the DLT in pp33 in Week7 Lecture8
% Get X Y Z u v data from inputs
% Hao Che, 17/05/2019

% Load data from inputs. Correspond XYZ and uv for same points.
length = size(XYZ,1);
X = XYZ(:,1);
Y = XYZ(:,2);
Z = XYZ(:,3);
u = uv(:,1);
v = uv(:,2);

%  Build A matrix
A = zeros(length*2,12);
% Consider w equal to 1.
for i = 1:length
    A(i*2-1,:) = [0,0,0,0,-X(i),-Y(i),-Z(i),-1,v(i)*X(i),v(i)*Y(i),v(i)*Z(i),v(i)];
	A(i*2,:) = [X(i),Y(i),Z(i),1,0,0,0,0,-u(i)*X(i),-u(i)*Y(i),-u(i)*Z(i),-u(i)];
end

% The way to solve the least square solution is using SVD to calculate
% results.% Compute SVD of A. Get the last column of V
[~,~,V] = svd(A); % each column of V represents a solution of P
P = V(:,end); % get last column

% Normalize last number of P to 1, and rearrange to obtain P
P =P./P(end); % The last element of C is 1

% Reshape to 3 x 4 matrix
P = reshape(P,[4 3]);
P = P';

imshow(im);
hold on;
% Plots the uv coordinates onto the image of the calibration target.
plot(uv(:,1),uv(:,2),'ro');
title('1.1 Calibrated Coordinates');
hold on;
% Projects the XYZ coordinates back into image coordinates
projected = [XYZ,ones(length,1)]';
xy = P*projected;

% get corresponding 2d corrdinates
xy(1,:) = xy(1,:)./xy(3,:);
xy(2,:) = xy(2,:)./xy(3,:);
xy = xy(1:2,:)';
% Show Mean Square Error
distance = immse(uv,xy);
disp('Mean Square Error is: ');
disp(num2str(distance));
plot(xy(:,1),xy(:,2),'g+');
hold on;
%Show the 3d coordination in image. These number are get from ginput.
x = line([310 389],[339 363],'Color','red','LineWidth',2); text(395,371,'X','Color','red','FontSize',14);
y = line([310 302],[339 248],'Color','green','LineWidth',2); text(305,240,'Y','Color','green','FontSize',14);
z = line([310 253],[339 381],'Color','yellow','LineWidth',2); text(230,376,'Z','Color','yellow','FontSize',14);

end

