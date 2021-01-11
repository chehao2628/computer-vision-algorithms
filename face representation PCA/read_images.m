%%
% This funciton reads all trainging images and convert them to
% corresponging formats for futher pca wroking.
function train_set = read_images(Path)
% This function reads all images from a directory Path.
% Return the a high dimensional matrix of images, as train sets or test
% set.

File = dir(strcat(Path,'\*.png'));  % get all images from this dir
FileNames = {File.name};

train_set = [];
for i = 1:length(File)
    path = strcat(Path,FileNames{i});
    img = imread(path);
    % represent each image as a single data point in a high dimensional space
    img1D = reshape(img, size(img,1)*size(img,2),1);
    train_set = [train_set,img1D]; % combine images to a set
end
end

