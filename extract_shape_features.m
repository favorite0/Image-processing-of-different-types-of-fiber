classdef extract_shape_features
    % 图像特征提取工具类
    
    methods (Static)
        
        %% 主函数：提取所有特征
        function all_features = extract_all_features(image_path)
            % 读取图像
            img = imread(image_path);
            
            % 转换为灰度图像
            if size(img, 3) == 3
                gray_img = rgb2gray(img);
            else
                gray_img = img;
            end
            
            % 二值化用于形状特征提取
            binary_img = imbinarize(gray_img);
            
            % 提取各种特征
            color_feat = ImageFeatureExtractor.extract_color_features(img);
            texture_feat = ImageFeatureExtractor.extract_texture_features(gray_img);
            shape_feat = ImageFeatureExtractor.extract_shape_features(binary_img);
            hog_feat = extractHOGFeatures(img);
            
            % 组合所有特征
            all_features = [color_feat; texture_feat(:); shape_feat(:); hog_feat(:)];
            
            % 特征归一化
            all_features = (all_features - min(all_features)) / (max(all_features) - min(all_features) + eps);
        end
        
        %% 颜色特征提取
        function color_features = extract_color_features(img)
            % 转换为 HSV 颜色空间
            if size(img, 3) == 3
                hsv_img = rgb2hsv(img);
                
                % 计算颜色直方图
                hue_hist = imhist(hsv_img(:,:,1), 16);  % H 通道
                sat_hist = imhist(hsv_img(:,:,2), 16);  % S 通道
                val_hist = imhist(hsv_img(:,:,3), 16);  % V 通道
                
                % 计算颜色矩
                color_mean = mean(reshape(img, [], 3));
                color_std = std(double(reshape(img, [], 3)));
                color_skew = skewness(double(reshape(img, [], 3)));
                
                % 组合颜色特征
                color_features = [hue_hist; sat_hist; val_hist; 
                                 color_mean(:); color_std(:); color_skew(:)];
            else
                % 对于灰度图像
                hist_features = imhist(img, 16);
                color_mean = mean(img(:));
                color_std = std(double(img(:)));
                color_skew = skewness(double(img(:)));
                color_features = [hist_features; color_mean; color_std; color_skew];
            end
        end
        
        %% 纹理特征提取
        function texture_features = extract_texture_features(gray_img)
            % GLCM 特征
            glcm = graycomatrix(gray_img, 'Offset', [0 1; -1 1; -1 0; -1 -1]);
            stats = graycoprops(glcm, {'contrast', 'correlation', 'energy', 'homogeneity'});
            
            % LBP 特征
            lbp_features = extractLBPFeatures(gray_img);
            
            % 组合纹理特征
            texture_features = [mean(stats.Contrast), mean(stats.Correlation), ...
                               mean(stats.Energy), mean(stats.Homogeneity), lbp_features];
        end
        
        %% 形状特征提取
        function shape_features = extract_shape_features(binary_img)
            % 区域属性
            stats = regionprops(binary_img, {'Area', 'Perimeter', 'Eccentricity',...
                                            'Solidity', 'Extent', 'MajorAxisLength',...
                                            'MinorAxisLength', 'Orientation'});
            
            % 选择最大区域
            if ~isempty(stats)
                [~, max_idx] = max([stats.Area]);
                shape_features = [stats(max_idx).Area, stats(max_idx).Perimeter, ...
                                 stats(max_idx).Eccentricity, stats(max_idx).Solidity,...
                                 stats(max_idx).Extent, stats(max_idx).MajorAxisLength,...
                                 stats(max_idx).MinorAxisLength, stats(max_idx).Orientation];
            else
                shape_features = zeros(1, 8);
            end
            
            % 计算 Hu 不变矩
            hu_moments = ImageFeatureExtractor.hu_moments(binary_img);
            shape_features = [shape_features, hu_moments];
        end
        
        %% Hu 不变矩计算
        function moments = hu_moments(binary_img)
            moments = zeros(1, 7);
            if any(binary_img(:))
                stats = regionprops(binary_img, 'Image');
                if ~isempty(stats)
                    [~, max_idx] = max([stats.Area]);
                    img_region = stats(max_idx).Image;
                    
                    % 计算矩
                    [y, x] = find(img_region);
                    if ~isempty(x) && ~isempty(y)
                        m00 = length(x);
                        m10 = sum(x); m01 = sum(y);
                        x_mean = m10/m00; y_mean = m01/m00;
                        
                        % 计算中心矩
                        mu11 = sum((x - x_mean) .* (y - y_mean));
                        mu20 = sum((x - x_mean).^2);
                        mu02 = sum((y - y_mean).^2);
                        mu30 = sum((x - x_mean).^3);
                        mu03 = sum((y - y_mean).^3);
                        mu12 = sum((x - x_mean) .* (y - y_mean).^2);
                        mu21 = sum((x - x_mean).^2 .* (y - y_mean));
                        
                        % 计算归一化中心矩
                        eta11 = mu11 / (m00^2);
                        eta20 = mu20 / (m00^2);
                        eta02 = mu02 / (m00^2);
                        eta30 = mu30 / (m00^2.5);
                        eta03 = mu03 / (m00^2.5);
                        eta12 = mu12 / (m00^2.5);
                        eta21 = mu21 / (m00^2.5);
                        
                        % 计算 Hu 不变矩
                        moments(1) = eta20 + eta02;
                        moments(2) = (eta20 - eta02)^2 + 4*eta11^2;
                        moments(3) = (eta30 - 3*eta12)^2 + (3*eta21 - eta03)^2;
                        moments(4) = (eta30 + eta12)^2 + (eta21 + eta03)^2;
                        moments(5) = (eta30 - 3*eta12)*(eta30+eta12)*((eta30+eta12)^2-3*(eta21+eta03)^2) + ...
                                    (3*eta21-eta03)*(eta21+eta03)*(3*(eta30+eta12)^2-(eta21+eta03)^2);
                        moments(6) = (eta20-eta02)*((eta30+eta12)^2-(eta21+eta03)^2) + ...
                                    4*eta11*(eta30+eta12)*(eta21+eta03);
                        moments(7) = (3*eta21-eta03)*(eta30+eta12)*((eta30+eta12)^2-3*(eta21+eta03)^2) - ...
                                    (eta30-3*eta12)*(eta21+eta03)*(3*(eta30+eta12)^2-(eta21+eta03)^2);
                    end
                end
            end
        end
        
        %% 批量处理图像特征
        function [feature_matrix, file_names] = batch_extract_features(image_folder, file_pattern)
            % 获取图像文件列表
            file_list = dir(fullfile(image_folder, file_pattern));
            num_images = length(file_list);
            
            % 预分配特征矩阵
            sample_features = ImageFeatureExtractor.extract_all_features(fullfile(image_folder, file_list(1).name));
            feature_matrix = zeros(num_images, length(sample_features));
            file_names = cell(num_images, 1);
            
            % 批量提取特征
            for i = 1:num_images
                try
                    img_path = fullfile(image_folder, file_list(i).name);
                    features = ImageFeatureExtractor.extract_all_features(img_path);
                    feature_matrix(i, :) = features';
                    file_names{i} = file_list(i).name;
                    fprintf('已处理图像 %d/%d: %s\n', i, num_images, file_list(i).name);
                catch ME
                    warning('处理图像 %s 时出错: %s', file_list(i).name, ME.message);
                    feature_matrix(i, :) = NaN(1, size(feature_matrix, 2));
                    file_names{i} = file_list(i).name;
                end
            end
        end
        
        %% 特征可视化
        function visualize_features(features, feature_names)
            figure;
            subplot(2,1,1);
            bar(features);
            title('图像特征向量');
            xlabel('特征维度');
            ylabel('特征值');
            
            if nargin > 1 && length(feature_names) == length(features)
                set(gca, 'XTick', 1:length(features), 'XTickLabel', feature_names);
                xtickangle(45);
            end
            
            subplot(2,1,2);
            feature_importance = abs(features) / sum(abs(features));
            [~, idx] = sort(feature_importance, 'descend');
            top_idx = idx(1:min(10, length(features)));
            pie(feature_importance(top_idx));
            title('前10个重要特征占比');
        end
    end
end