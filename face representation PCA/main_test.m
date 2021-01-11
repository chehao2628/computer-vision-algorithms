%%
% Run this file to show pca recognizer results
train_Path = 'Yale-FaceA\trainingset\'; % Get the train dataset images
test_Path = 'Yale-FaceA\testset\'; % Get the test dataset images
k = 10;
train_set = read_images(train_Path);
[ui,m, A] = pca(train_set, k);
train_set = read_images(train_Path); % 45045 dimension, 135 pictures
test_set = read_images(test_Path); % 45045 dimension, 10 pictures
num_test = size(test_set,2);
count = 1; % Used to count the plotting number
for i = 1:num_test
	test_img = test_set(:,i);
	test_img = uint8(reshape(test_img,231,195));
    subplot(num_test,4,count);
    imshow(test_img);
    count = count + 1;
    title(strcat('Test image',int2str(i)));
    % Show three match images in train set
    index_list = recognizer(ui, m, A, test_set(:,i));
    for j = 1:3
        train_img = train_set(:,index_list(j));
        train_img = uint8(reshape(train_img,231,195));
        subplot(num_test,4,count);
        count = count + 1;
        imshow(train_img);
        title(strcat('Top',int2str(j),'. nearest train image'));
    end
end
