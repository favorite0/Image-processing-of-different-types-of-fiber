function [feature_table, summary_stats] = batch_shape_analysis(image_folder, file_pattern)
    % 批量分析图像形状特征
    
    % 获取图像文件
    file_list = dir(fullfile(image_folder, file_pattern));
    num_images = length(file_list);
    
    % 预分配特征表
    sample_img = imread(fullfile(image_folder, file_list(1).name));
    if size(sample_img, 3) == 3
        sample_img = rgb2gray(sample_img);
    end
    sample_features = extract_advanced_shape_features(imbinarize(sample_img));
    
    feature_names = fieldnames(sample_features);
    feature_table = table('Size', [num_images, length(feature_names)], ...
                         'VariableNames', feature_names, ...
                         'VariableTypes', repmat({'double'}, 1, length(feature_names)));
    
    % 处理每个图像
    for i = 1:num_images
        try
            % 读取并预处理图像
            img_path = fullfile(image_folder, file_list(i).name);
            img = imread(img_path);
            
            if size(img, 3) == 3
                img = rgb2gray(img);
            end
            
            binary_img = imbinarize(img);
            
            % 提取特征
            features = extract_advanced_shape_features(binary_img);
            
            % 存储特征
            for j = 1:length(feature_names)
                feature_table{i, feature_names{j}} = features.(feature_names{j});
            end
            
            fprintf('已处理: %s\n', file_list(i).name);
            
        catch ME
            warning('处理 %s 时出错: %s', file_list(i).name, ME.message);
        end
    end
    
    % 计算统计摘要
    summary_stats = struct();
    for j = 1:length(feature_names)
        feature_data = feature_table{:, feature_names{j}};
        summary_stats.(feature_names{j}).Mean = mean(feature_data, 'omitnan');
        summary_stats.(feature_names{j}).Std = std(feature_data, 'omitnan');
        summary_stats.(feature_names{j}).Min = min(feature_data, [], 'omitnan');
        summary_stats.(feature_names{j}).Max = max(feature_data, [], 'omitnan');
    end
    
    % 保存结果
    writetable(feature_table, 'shape_features.csv');
    save('shape_analysis_results.mat', 'feature_table', 'summary_stats');
    
    fprintf('分析完成！结果已保存到 shape_features.csv 和 shape_analysis_results.mat\n');
end