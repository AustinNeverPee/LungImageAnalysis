% function [ lung_segmented ] = Segmentation( lung_extracted, lung_floodfilled )
% function [] = Segmentation( lung_extracted, lung_floodfilled )
function [ F, idx, K , pic_color] = Segmentation( lung_dilated, lung_extracted )
% Lung Regions Segmentation
%   segment lung region to find the cancer nodules
%   identify the region of interest(ROIs) which helps in determining the
%   cancer region
% Return
%   F: location info of points
%   idx: cluster that point is classified to
%   K: no. of clusters
%% extract fetures
[height, width] = size(lung_dilated);
F = [];
count = 1;
for h = 1:height
    for w = 1:width
        if lung_dilated(h, w) == true
            F(count, :) = [h, w];
            count = count + 1;
        end
    end
end
%% kmeans parameter
K = 8;
%% cluster
[idx, C] = kmeans(F, K);
% show clusters
pic_color = ColorCluster(lung_extracted, idx, F, K);

% %% turn gray to rgb
% % I     = ind2rgb(lung_extracted, colormap);
% I     = lung_extracted;
% J     = lung_floodfilled;
% %% parameters
% % kmeans parameter
% K     = 8;                  % Cluster Numbers
% KMI   = 20;                 % K-means Iteration
% % meanshift parameter
% bw    = 0.2;                % Mean Shift Bandwidth
% % ncut parameters
% SI    = 5;                  % Color similarity
% SX    = 6;                  % Spatial similarity
% r     = 1.5;                % Spatial threshold (less than r pixels apart)
% sNcut = 0.21;               % The smallest Ncut value (threshold) to keep partitioning
% sArea = 80;                 % The smallest size of area (threshold) to be accepted as a segment
% %% compare
% % K-Means
% Ikm2         = Km2(I, J, K, KMI);             % Kmeans (color + spatial)
% % Mean-Shift
% % [Ims2, Nms2] = Ms2(I,bw);                   % Mean Shift (color + spatial)
% % Normalized Graph Cut
% % [Inc, Nnc]   = Nc(I,SI,SX,r,sNcut,sArea);   % Normalized Cut
% %% show
% figure()
% subplot(221); imshow(I);    title('Original'); 
% subplot(222); imshow(Ikm2); title('K-Means'); 
% % subplot(222); imshow(Ims2); title('Mean-Shift');
% % subplot(224); imshow(Inc);  title(['NormalizedCut',' : ',num2str(Nnc)]);
% %% write
% imwrite(Ikm2, 'detection/Im2.bmp');
end