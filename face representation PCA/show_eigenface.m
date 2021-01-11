%%
% Run this file to show top 10 eigen faces of dataset.
Path = 'Yale-FaceA\trainingset\'; % Get the train dataset images
k =10;
[ui, m, A] = pca(Path, k);

% Show top 10 eigen faces of dataset.
row = uint8(k/5);
for i = 1:k
    img = ui(:,i) + m; % add the mean face back.
    img = uint8(reshape(img,231,195));
    subplot(2,5,i);
    imshow(img,[]);
    title(i);
%    %name = strcat(num2str(i),'.png');
%    %imwrite(img,name);
end
