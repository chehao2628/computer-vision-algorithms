%%
function [ui, m, A] = pca(train_set,k)
% Read all the 135 training images from Yale-Face, represent each image as a single
% data point in a high dimensional space and collect all the data points into a big data
% matrix.

num_train = size(train_set,2);
% Perform PCA on the data matrix. The following code refer to the lecture08
% Step 1 Compute sample mean
m = mean(train_set,2);

% Display mean face
%m_img = uint8(reshape(m,231,195));
%imshow(m_img);
%title('Mean face of the dataset')

% Step 2 and 3 Substract mean and Form matrix A
M = [];  % store all mean values and expend dimension
for i = 1 : num_train
    M = [M m];
end
A = double(train_set) - M;    
% Compute sample covariance
% covariance = (A*A')/num_train; % covariance based on NORMAL PCA
covariance = A'*A; % covariance based on NEW PCA Solution refer to lecture09

% Step 4 and 5 Compute eigenvalues and eigenvectors of covariance
[EgienValue,~] = eig(covariance);  % The order process has been included in eig() function

% Step 5 Get k largest eigen values, defined as qi
EgienVector = [];
for i = size(EgienValue,2)-k+1 : size(EgienValue,2) 
    EgienVector = [EgienVector,EgienValue(:,i)];
end

% Step 6 Compute eigen vectors ui of the original covariance matrix
ui = A * EgienVector; % ui = Aqi is not normalized.

end

