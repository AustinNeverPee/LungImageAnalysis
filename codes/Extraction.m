% function [ lung_extracted, lung_floodfilled ] = Extraction( img_orig )
function [ lung_dilated, lung_extracted,...
    bit_plane, img_eroded, img_median, img_dilated, img_outlined, extraction_region, lung_floodfilled ] = Extraction( img_orig )
% Lung Regions Extractions
%   initial stage of CAD
%   extract lung region from the CT scan image

% Lung Region Extraction
%   choose the best suitable slice with better accuracy and sharpness
% Bit-Plane Slicing
% Plane Splitting
[height, width] = size(img_orig);
bit_planes = zeros(height, width, 8);
% figure('NumberTitle', 'off', 'name', 'Plane Splitting'), 
% subplot(3, 3, 1); imshow(img_orig); title('original image')
for i = 1:8
   bit_planes(:, :, i) = bitget(img_orig, i);
%    % show
%    subplot(3, 3, i+1); imshow(bit_planes(:, :, i)), title(['Bit Plane ', num2str(i)]);
%    % write
%    imwrite(bit_planes(:, :, i), ['plane_splitting/bit plane ', num2str(i), '.bmp']);
end 

% Plane Combination
com_planes = zeros(height, width, 7);
% figure('NumberTitle', 'off', 'name', 'Plane Combination'), 
% subplot(3, 3, 1); imshow(img_orig); title('original image')
for i = 2:8
    for j = 8:-1:i
        com_planes(:, :, i-1) = bitset(com_planes(:, :, i-1), j, bit_planes(:, :, j));
    end
%     % show
%     subplot(3, 3, i); imshow(uint8(com_planes(:, :, i-1))); title(['8~', num2str(i)]);
%     %write
%     imwrite(uint8(com_planes(:, :, i-1)), ['plane_combination/8-', num2str(i), '.bmp']);
end


bit_plane = uint8(com_planes(:, :, 1)); % output 1


% Erosion
%   enhance the sliced image by reducing the noise
% result of the previous step
img_proc_1 = im2bw(uint8(com_planes(:, :, 1)), 0.8);
% img_proc_1 = imbinarize(com_planes(:, :, 1));
% structuring element object
se_ero = [1 1 1; 1 1 1; 1 1 1];
% se = [1, 1; 1, 1];
% erode the image
img_eroded = imerode(img_proc_1, se_ero); % output 2
% % show
% figure('NumberTitle', 'off', 'name', 'Image Erosion'),
% subplot(1, 2, 1); imshow(img_proc_1); title('before erosion');
% subplot(1, 2, 2); imshow(img_eroded); title('after erosion');
% % write
% imwrite(img_proc_1, 'erosion/img_before_eroded.bmp');
% imwrite(img_eroded, 'erosion/img_after_eroded.bmp');



% Median Filter
%   enhance image for further improvement from othe distortion
% result of the previous step
img_proc_2 = img_eroded;
% median-filter the image
img_median = medfilt2(img_proc_2); % output 3
% % show 
% figure('NumberTitle', 'off', 'name', 'Median Filter'),
% subplot(1, 2, 1); imshow(img_proc_2); title('before median-filtering');
% subplot(1, 2, 2); imshow(img_median); title('after median-filtering');
% % write
% imwrite(img_proc_2, 'median_filter/img_before_filter.bmp');
% imwrite(img_median, 'median_filter/img_after_filter.bmp');



% Dilation
%   enhance image for further improvement from othe distortion
% result of the previous step
img_proc_3 = img_median;
% structuring element object
se_dil = [1 1 1; 1 1 1; 1 1 1];
% dilate the image
img_dilated = imerode(img_proc_3, se_dil); % output 4
% % show
% figure('NumberTitle', 'off', 'name', 'Dilation'),
% subplot(1, 2, 1); imshow(img_proc_3); title('before dilation');
% subplot(1, 2, 2); imshow(img_dilated); title('after dilation');
% % write
% imwrite(img_proc_3, 'dilation/img_before_dilation.bmp');
% imwrite(img_dilated, 'dilation/img_after_dilation.bmp');



% Outlining
%   determine the outline of the regions
% result of the previous step
img_proc_4 = img_dilated;
% get the outline
[B,L] = bwboundaries(img_proc_4, 'holes');
% draw the outline
img_outlined = false(height, width); % output 5
for k = 1:length(B)
    boundary = B{k};
    for j = 1:length(boundary)
        img_outlined(boundary(j, 1), boundary(j, 2)) = 1;
    end
end
% % show
% figure('NumberTitle', 'off', 'name', 'Outlining'),
% subplot(1, 2, 1); imshow(img_proc_4); title('before outlining');
% subplot(1, 2, 2); imshow(img_outlined); title('after outlining');
% % write
% imwrite(img_proc_4, 'outlining/img_before_outlining.bmp');
% imwrite(img_outlined, 'outlining/img_after_outlining.bmp');
% imshow(label2rgb(L, @jet, [0.5 0.5 0.5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end



% Lung Border Extraction
%   find the lung border from the boundaries of previous step
% find the boundary that has the largest area
area_largest = 0;
index_largest = 0;
bound_y_x = zeros(length(B), 4); % y_min, y_max, x_min, x_max
% for every boundary
for k = 1:length(B)
    boundary = B{k};
    % find the largest, smallest x, y
    x_min = 9999;
    y_min = 9999;
    x_max = 0;
    y_max = 0;
    for j = 1:length(boundary)
        if x_min > boundary(j, 2)
            x_min = boundary(j, 2);
        end
        if y_min > boundary(j, 1)
            y_min = boundary(j, 1);
        end
        if x_max < boundary(j, 2)
            x_max = boundary(j, 2);
        end
        if y_max < boundary(j, 1)
            y_max = boundary(j, 1);
        end
    end
    bound_y_x(k, :) = [y_min, y_max, x_min, x_max];
    % calculate the area
    area_bound = (x_max - x_min) * (y_max - y_min);
    if area_bound >area_largest
        area_largest = area_bound;
        index_largest = k;
    end
end
% cannot find the proper boundary
if index_largest == 0
    disp('cannot find the proper boundary')
    exit
end
% delete the largest boundary and the boundary outside it
index_del = [];
index_del(1) = index_largest;
num_del = 1;
% for every boundary
for k = 1:length(B)
    if k == index_largest
        continue
    end
    % judge whether outside or not
    if bound_y_x(k, 1) < bound_y_x(index_largest, 1)...
            || bound_y_x(k, 2) > bound_y_x(index_largest, 2)...
            || bound_y_x(k, 3) < bound_y_x(index_largest, 3)...
            || bound_y_x(k, 4) > bound_y_x(index_largest, 4)
        num_del = num_del + 1;
        index_del(num_del) = k;
    end
end
% get the lung boundary
bound_region = cell(length(B) - num_del, 1);
index_lung = 0;
for k = 1:length(B)
    if ~ismember(k, index_del)
        index_lung = index_lung + 1;
        bound_region{index_lung} = B{k};
    end
end
% draw the lung region boundary
extraction_region = false(height, width); % output 6
for k = 1:length(bound_region)
    boundary = bound_region{k};
    for j = 1:length(boundary)
        extraction_region(boundary(j, 1), boundary(j, 2)) = 1;
    end
end
% % show
% figure('NumberTitle', 'off', 'name', 'Lung Border Extraction'),
% subplot(1, 2, 1); imshow(img_outlined); title('before extraction');
% subplot(1, 2, 2); imshow(extraction_region); title('after extraction');
% % write
% imwrite(img_outlined, 'lung _border_extraction/img_before_extraction.bmp');
% imwrite(extraction_region, 'lung _border_extraction/img_after_extraction.bmp');



% Flood Fill Algorithm
%   fill the obtained lung border with the lung region    
% find the two parts of lung(left and right)
largest_two = [0, 0]; % 1st > 2nd
index_two = [0, 0];
for k = 1:length(bound_region)
    if length(bound_region{k}) > largest_two(1)
        largest_two(2) = largest_two(1);
        largest_two(1) = length(bound_region{k});
        index_two(2) = index_two(1);
        index_two(1) = k;
    elseif length(bound_region{k}) > largest_two(2)
        largest_two(2) = length(bound_region{k});
        index_two(2) = k;
    end
end
% find the minimum bounding box
b_box = [9999, 0, 9999, 0]; % [top, down, left, right]
for k = 1:2
    boundary = bound_region{index_two(k)};
    for j = 1:length(boundary)
        if b_box(3) > boundary(j, 2)
            b_box(3) = boundary(j, 2);
        end
        if b_box(1) > boundary(j, 1)
            b_box(1) = boundary(j, 1);
        end
        if b_box(4) < boundary(j, 2)
            b_box(4) = boundary(j, 2);
        end
        if b_box(2) < boundary(j, 1)
            b_box(2) = boundary(j, 1);
        end
    end
end
% draw the lung boundary
extraction_lung = false(height, width);
for k = 1:2
    boundary = bound_region{index_two(k)};
    for j = 1:length(boundary)
        extraction_lung(boundary(j, 1), boundary(j, 2)) = 1;
    end
end
% floodfill the lung
lung_floodfilled = imfill(extraction_lung, 'holes');
% cut out the boundary for the use of segmentation
for k = 1:2
    boundary = bound_region{index_two(k)};
    for j = 1:length(boundary)
        lung_floodfilled(boundary(j, 1), boundary(j, 2)) = 0;
    end
end
% extract the lung from the original image
lung_extracted = img_orig;
for h = 1:height
    for w = 1: width
        if lung_floodfilled(h, w) == false
            lung_extracted(h, w) = 0;
        end
    end
end
lung_dilated = img_dilated;
for h = 1:height
    for w = 1: width
        if lung_floodfilled(h, w) == false
            lung_dilated(h, w) = 0;
        end
    end
end
% crop the image according to min bounding box
lung_floodfilled = imcrop(lung_floodfilled, [b_box(3), b_box(1), b_box(4) - b_box(3), b_box(2) - b_box(1)]); % output 7
lung_extracted = imcrop(lung_extracted, [b_box(3), b_box(1), b_box(4) - b_box(3), b_box(2) - b_box(1)]); 
lung_dilated = imcrop(lung_dilated, [b_box(3), b_box(1), b_box(4) - b_box(3), b_box(2) - b_box(1)]);

% % show
% figure('NumberTitle', 'off', 'name', 'Flood Fill'),
% subplot(1, 2, 1); imshow(lung_floodfilled); title('flood fill');
% subplot(1, 2, 2); imshow(lung_extracted); title('extracted lung');
% % write
% imwrite(lung_floodfilled, 'flood_fill/img_floodfilled.bmp');
% imwrite(lung_extracted, 'flood_fill/img_lung_extracted.bmp');
end