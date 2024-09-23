% Read the image
img = imread('im3.png');  
img_gray = im2gray(img);  

% Display the original grayscale image
figure;
imshow(img_gray);
title('Original Grayscale Image');

% Apply Otsu's thresholding with a custom adjustment
level = graythresh(img_gray); 
threshold_adjustment = 0.8;  % Adjustment factor (can be tuned)
adjusted_level = level * threshold_adjustment; 

binary_img = imbinarize(img_gray, adjusted_level);

% Display the binary image after thresholding and additional refinement
figure;
imshow(binary_img);
title(['Binary Image After Adjusted Otsu Thresholding (Adjustment: ', num2str(threshold_adjustment), ')']);

% Identify connected components
connectivity = 8;
connected_components = bwconncomp(binary_img, connectivity);

% Calculate properties of the connected components
props = regionprops(connected_components, 'Centroid', 'Area');

% Check if centroids are detected
if isempty(props)
    disp('No droplets detected.');
    return;
end

% Extract centroids
centroids = cat(1, props.Centroid);

% Display the binary image with centroids plotted
figure;
imshow(binary_img);
hold on;

% Plot the centroids on the image
plot(centroids(:,1), centroids(:,2), 'r+', 'MarkerSize', 5, 'LineWidth', 1);

% Calculate Voronoi cells
[vx, vy] = voronoi(centroids(:,1), centroids(:,2));

% Plot Voronoi cells
plot(vx, vy, 'g-', 'LineWidth', 0.5);  % Thinner Voronoi lines

% Display Voronoi regions (polygons) using voronoin
[v, c] = voronoin(centroids);

% Plot the Voronoi polygons without filling them
for i = 1:length(c)
    if all(c{i} ~= 1)   % Skip cells that are at infinity
        plot(v(c{i},1), v(c{i},2), 'g-', 'LineWidth', 0.5);  % Plot Voronoi edges
    end
end

hold off;

% Display the number of droplets identified
disp(['Number of droplets identified: ', num2str(size(centroids, 1))]);
