function [ Fs ] = FeatureExtraction( C, idx, K )
% Extract features of nodule candidates
% Three kinds of features:
%   1.Area of the candidate region
% %   2.The Maximum Drawable Circle(MDC) inside the candidate region
%   2.Area of box that contain nodule candidate
%   3.Mean intensity value of the candidate region

% Return(Fs)
%   Row: nodule candidate
%   Col: feature
%% Feature 1: Area of the candidate region
% use the no. of pixel to replace area
F1 = zeros(K, 1);
for k = 1:K
    F1(k) = sum(idx == k);
end
%% Feature 2: Area of box that contain nodule candidate
F2 = zeros(K, 1);
for k = 1:K
    C_k = C(idx == k, :);
    % find the minimum bounding box
    b_box = [9999, 0, 9999, 0]; % [top, down, left, right]
    for j = 1:size(C_k, 1)
        if b_box(3) > C_k(j, 2)
            b_box(3) = C_k(j, 2);
        end
        if b_box(1) > C_k(j, 1)
            b_box(1) = C_k(j, 1);
        end
        if b_box(4) < C_k(j, 2)
            b_box(4) = C_k(j, 2);
        end
        if b_box(2) < C_k(j, 1)
            b_box(2) = C_k(j, 1);
        end
    end
    F2(k) = (b_box(2) - b_box(1)) * (b_box(4) - b_box(3));
end
% %% Feature 2: The Maximum Drawable Circle(MDC) inside the candidate region
% % use box to replace circle
% F2 = zeros(K, 1);
% for k = 1:K
%     C_k = C(idx == k, :);
%     for i = 1:length(C_k)
%         center = C_k(i, :);
%         r = 0;
%         border = zeros(4, 2);
%         while 1
%             r = r + 1;
%             border(1, :) = center - [r, 0];
%             border(2, :) = center + [r, 0];
%             border(3, :) = center - [0, r];
%             border(4, :) = center + [0, r];
%             count = 0;
%             for j = 1:4
%                 y_b = find(C_k(:, 1) == border(j, 1));
%                 if isempty(y_b)
%                     continue;
%                 end
%                 flag = false;
%                 for m = 1:length(y_b)
%                     if find(y_b(m), 2) == border(j, 2)
%                         flag = true;
%                         continue;
%                     end
%                 end
%                 if flag
%                     count = count + 1;
%                 end
%             end
%             if count ~= 4
%                 r = r - 1;
%                 break;
%             end
%         end
%         if r > F2(k)
%             F2(k) = r;
%         end
%     end
% end
%% Feature 3: Mean intensity value of the candidate region
F3 = zeros(K, 1);
r = 4;          % radius
for k = 1:K
    C_k = C(idx == k, :);
    for i = 1:size(C_k, 1)
        % use box to replace circle
        range_y = [C_k(i, 1) - r, C_k(i, 1) + r];
        range_x = [C_k(i, 2) - r, C_k(i, 2) + r];
        
        intensity = 0;
        for j = 1:size(C_k, 1)
            if C_k(j, 1) > range_y(1) && C_k(j, 1) < range_y(2) && C_k(j, 2) > range_x(1) && C_k(j, 2) < range_x(2)
                intensity = intensity + 1;
            end
        end
        F3(k) = F3(k) + intensity;
    end
    F3(k) = F3(k) / size(C_k, 1);
end
%% combined feature
Fs = [F1, F2, F3];
end