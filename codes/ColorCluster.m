% function [ pic_color ] = ColorCluster( pic_orig, K )
function [ pic_color ] = ColorCluster( pic_orig, idx, F, K )
% Give different colors to clusters we get
% Make the result much more clear

%% turn gray to rgb
pic_color = cat(3, pic_orig, pic_orig, pic_orig);
%% define different colors to show clustering
labels = [uint8(cat(3, 255, 0, 0)), ...         % red
    uint8(cat(3, 0, 255, 0)), ...               % green
    uint8(cat(3, 0, 0, 255)), ...               % blue
    uint8(cat(3, 255, 255, 0)), ...             % yellow
    uint8(cat(3, 255, 0, 255)), ...             % magenta
    uint8(cat(3, 0, 255, 255)), ...             % cyan
    uint8(cat(3, 255, 255, 255)), ...           % white
    uint8(cat(3, 255, 110, 180))];              % pink
%% assign color to according point
for i = 1:size(idx, 1)
    for k = 1:K
        if k == idx(i)
            pic_color(F(i, 1), F(i, 2), :) = labels(1, k, :);
            break;
        end
    end
end
%% show colored clusters
% figure('NumberTitle', 'off', 'name', 'Nodule Dectection'),
% imshow(pic_color);
%% write
% imwrite(pic_color, 'detection/kmeans.bmp');

% for k = 1:K
%     [idx_i, idx_j] = find(pic_orig == k);
%     for i = 1:size(idx_i)
%         pic_color(idx_i(i), idx_j(i), :) = labels(1, k, :);
%     end
% end

end

