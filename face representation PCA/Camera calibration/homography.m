%%
function H = homography(u2Trans, v2Trans, uBase, vBase)
%% TASK 2: 
% Computes the homography H applying the Direct Linear Transformation 
% The transformation is such that 
% p = H p' , i.e.,:  
% (uBase, vBase, 1)'=H*(u2Trans , v2Trans, 1)' 
% 
% INPUTS: 
% u2Trans, v2Trans - vectors with coordinates u and v of the transformed image point (p') 
% uBase, vBase - vectors with coordinates u and v of the original base image point p  
% 
% OUTPUT 
% H - a 3x3 Homography matrix  
% 
% Hao Che, 18/05/2019
A = zeros(12,9); 
for i=1:6 %identify the caculation matrix. 
    A((i-1)*2+1,:)= [0, 0, 0, -uBase(i), -vBase(i), -1, v2Trans(i)*uBase(i), v2Trans(i)*vBase(i), v2Trans(i)];
    A((i-1)*2+2,1:9,:) = [uBase(i), vBase(i), 1, 0, 0, 0, -u2Trans(i)*uBase(i), -u2Trans(i)*vBase(i), -u2Trans(i)];
end
 
% results.% Compute SVD of A. Get the last column of V
[~,~,V]=svd(A); % each column of V represents a solution of P
h= V(:,end); % get last column
h=h./h(end); % The last element of matrix H is 1

% Reshape to 3 x 3 matrix
H= reshape(h,3,3)'; 
end

