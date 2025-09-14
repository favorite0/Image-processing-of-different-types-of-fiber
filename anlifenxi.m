% 使用示例
clear; clc;

% 方法1：直接处理二值图像
binary_image = imbinarize(imread('D:\工作\\MATLAB\部分数据集\扩大裁剪1\k1-b1.jpg'));
features = extract_advanced_shape_features(binary_image);

% 显示主要形状特征
fprintf('面积: %.2f\n', features.Area);
fprintf('周长: %.2f\n', features.Perimeter);
fprintf('周长比: %.2f\n', features.PerimeterRatio);
fprintf('圆度: %.4f\n', features.Circularity);
fprintf('紧密度: %.4f\n', features.Compactness);

% 方法2：批量处理
% image_folder = 'your_images_folder';
% [feature_table, stats] = batch_shape_analysis(image_folder, '*.jpg');

% 方法3：创建测试图像进行分析
main_shape_feature_extraction();