%%
% Run this file to show my face recognization results
% Task 2.5 Read in one of your own frontal face images. Then run your face recognizer on
% this new image. Display the top 3 faces in the training folder that are most similar to
% your own face
train_Path = 'Yale-FaceA\trainingset\'; % Get the train dataset images
myface_Path = 'Self-Face\aligned\'; % Get my face dataset images
k = 10;
train_set = read_images(train_Path);
[ui,m, A] = pca(train_set, k);
train_set = read_images(train_Path); % 45045 dimension, 135 pictures
myface_set = read_images(myface_Path); % 45045 dimension, 10 pictures
num_test = 1;% only test 1 face

figure('name','test my face with orginal dataset');
count = 1; % Used to count the plotting number
facce_img = myface_set(:,4); % get a image
facce_img = uint8(reshape(facce_img,231,195));

subplot(num_test,4,count);
imshow(facce_img);
count = count + 1;
title(strcat('Test image of my face'));
% Show three match images in train set
index_list = recognizer(ui, m, A, myface_set(:,4));
for j = 1:3
    train_img = train_set(:,index_list(j));
    train_img = uint8(reshape(train_img,231,195));
	subplot(num_test,4,count);
	count = count + 1;
	imshow(train_img);
	title(strcat('Top',int2str(j),'. nearest train image'));
end

% task 2.6 Add my face to train set and do the above test
figure('name','test my face with extended dataset');
for i = 1:10
    if i~=4
       % Add my face to train set
       train_set = [train_set,myface_set(:,i)]; 
    end
    
end
[ui2,m2, A2] = pca(train_set, k);

count = 1;
subplot(num_test,4,count);
imshow(facce_img);
count = count + 1;
title(strcat('Test image of my face'));
% Show three match images in train set
index_list = recognizer(ui2, m2, A2, myface_set(:,4));
for j = 1:3
    train_img = train_set(:,index_list(j));
    train_img = uint8(reshape(train_img,231,195));
	subplot(num_test,4,count);
	count = count + 1;
	imshow(train_img);
	title(strcat('Top',int2str(j),'. nearest train image'));
end


