%%
function clusters = my_kmeans(data, k)
% This function implement K-means algorithm to segment color image
% coordinates of corners of image.
% Input: data   data points to be processed (for k-means it is a n D vector)
% Input: k   the number of clusters (a Grayscale image or a matrix) 
% return: clusters   index list stores corresponding centers for each pixel
m = size(data,1); % length of data 
n = size(data,2); % width of data 
d = size(data,3); % depth of data 
% The annotations of following steps refer to the 

% Setp 1. Arbitrarily initialize centroids (there are K centroids).
rng('default'); % resets seeds to the original value
centerX = randperm(m, k);
centerY = randperm(n, k);
centers = zeros(k,d); % Initilize cluster centers
for i = 1:k
    centers(i,:) = data(centerX(i),centerY(i),:); % Get k random points as cluster center.
end
index = zeros(m,n,1); % stores index of k means centers. 
iteration = 0; % detect the iterations and stop early.
while true
	previous_index = index;
    % Setp 2. Assign datapoints to the closest cluster (based on the Euclidean distance).
    for i = 1 : m
        for j = 1 : n
            min_distance = inf;
            for p = 1 : k
                distance = sqrt(sum((reshape(data(i,j,:),1,d) - centers(p,:)).^2)); % EUCLIDEAN DISTANCE
                if distance < min_distance
                    min_distance = distance;
                    index(i,j,:) = p;
                end
            end
        end
    end
    % Setp 3. Update the centroid by taking the average based on the new assignment to each cluster.
    for p = 1 : k
        temp_data = zeros(1,d);
        count = 0;
        for i = 1 : m
            for j = 1 : n
                if index(i,j) == p
                    % sums the points belong to a cluster center
                    temp_data = temp_data + reshape(data(i,j,:),1,d);
                    count = count + 1; % Adding base number
                end
            end
        end
        centers(p,:) = temp_data./count;
    end
    % Setp 4. If the differences of new centroids and old centroids are 
    % larger than the stopping criteria, back to (2). Otherwise, break the
    % loop.
    if index == previous_index
        break;
    end
    % Set Stop early and show current iteration
    iteration = iteration + 1
    if iteration > 15
        break;
    end
end
% Transfer index to cell array for clusters
clusters = {};
for p = 1:k
    cluster = [];
    for i = 1:m
        for j = 1:n
            if index(i,j) == p
                cluster(end+1,:) = [i,j];
            end
        end
    end
    % Get several clusters of points for outputs
    clusters{end+1} = cluster;
end
end