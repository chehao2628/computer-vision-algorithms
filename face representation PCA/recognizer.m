%%
function train_index_list = recognizer(ui, m, A, test_image)
% This function retrun the index array contains top 3 nearest images to
% test image

% Process labeled training images
project_images = [];
train_num = size(A,2);
for i = 1 : train_num
    % Project each training image xi onto subspace spanned by principal components:
    projection = ui' * A(:,i);  % Following equation of projection
    project_images = [project_images,projection]; 
end

% Process test images
testA = double(test_image) - m;
projected_test = ui'*testA;

% Classify as closest training face in k-dimensional subspace
distance = [];
for i = 1 : train_num
    q = project_images(:,i);
    dist = sqrt(sum((projected_test - q).^2));
    distance = [distance, dist];
end
[~,train_index] = sort(distance); % Get index of sorted distance
train_index_list = train_index(1:3);
%output_name = strcat(int2str(test_index),'.png');
end

