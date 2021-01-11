%%
function clusters = my_kmeans_plus(data, k)
% This function implement K-means++ algorithm to segment color image
% coordinates of corners of image.
% Input: data   data points to be processed (for k-means it is a n D vector)
% Input: k   the number of clusters (a Grayscale image or a matrix) 
% return: clusters   index list stores corresponding centers for each pixel
m = size(data,1); % length of data 
n = size(data,2); % width of data 
d = size(data,3); % depth of data 
% The annotations of following steps refer to the 

% Use K-means++ to initialize centroids
% First. take one random point as cluster center at first.
rng('default'); % resets seeds to the original value
centerX = randperm(m, 1);
centerY = randperm(n, 1);
centers = zeros(k,d); % Initilize cluster centers
centers(1,:) = data(centerX(1),centerY(1),:); % Initilize first cluster center

Dx = zeros(m,n);
Px = zeros(m,n);
% Second, calculate the shortest distance between each sample and the 
% current clustering center and store these distances to D(x).
for i = 1:m
   for j = 1:n
      Dx(i,j) = sum((reshape(data(i,j,:),1,d) - centers(1,:)).^2); % EUCLIDEAN DISTANCE but no sqrt here
   end
end
% Third, calculate and select the next cluster center based on probability D(x)2 /sum(D(x)2).
sum_Dx = sum(sum(Dx));
for i = 1:m
   for j = 1:n
      % P(x) = D(x)2 /sum(D(x)2).
      Px(i,j) = Dx(i,j)/sum_Dx;
   end
end
Px = reshape(Px, m*n,1);
sum_x = cumsum(Px);
temp_data = reshape(data,m*n,d); % speed up find data values
% Select centers,
for p = 2:k
   %next = randperm(m*n, 1);
   next = rand(1);
   for i = 1:size(sum_x,1)
      if sum_x(i) >  next
          break;
      end
   end
   centers(p,:) = temp_data(i,:); % assign valuest to centers
end

% select centers by kmeans++ has been implemented. GO ON the kmeans from
% second step.

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


%function centers = select_center(first_center, data, k)

%