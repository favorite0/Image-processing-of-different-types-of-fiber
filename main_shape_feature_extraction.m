function main_shape_feature_extraction()
    % 主函数：形状特征提取示例
    
    % 创建示例图像（圆形）
    [x, y] = meshgrid(1:100, 1:100);
    circle_img = sqrt((x-50).^2 + (y-50).^2) <= 30;
    
    % 创建示例图像（矩形）
    rect_img = false(100, 100);
    rect_img(20:80, 30:70) = true;
    
    % 创建示例图像（复杂形状）
    complex_img = false(100, 100);
    complex_img(10:90, 20:80) = true;
    complex_img(40:60, 40:60) = false;
    
    % 提取特征
    features_circle = extract_advanced_shape_features(circle_img);
    features_rect = extract_advanced_shape_features(rect_img);
    features_complex = extract_advanced_shape_features(complex_img);
    
    % 显示结果
    display_features('圆形', features_circle);
    display_features('矩形', features_rect);
    display_features('复杂形状', features_complex);
    
    % 可视化比较
    visualize_comparison(features_circle, features_rect, features_complex);
end

function display_features(shape_name, features)
    % 显示特征值
    fprintf('\n=== %s 特征 ===\n', shape_name);
    fprintf('面积: %.2f\n', features.Area);
    fprintf('周长: %.2f\n', features.Perimeter);
    fprintf('周长比: %.2f\n', features.PerimeterRatio);
    fprintf('圆度: %.4f\n', features.Circularity);
    fprintf('紧密度: %.4f\n', features.Compactness);
    fprintf('矩形度: %.4f\n', features.Rectangularity);
    fprintf('纵横比: %.4f\n', features.AspectRatio);
    fprintf('凸性: %.4f\n', features.Convexity);
    fprintf('实心度: %.4f\n', features.Solidity);
end

function visualize_comparison(features1, features2, features3)
    % 可视化特征比较
    
    feature_names = {'Circularity', 'Compactness', 'Rectangularity', 'Convexity', 'Solidity'};
    values1 = [features1.Circularity, features1.Compactness, features1.Rectangularity, ...
              features1.Convexity, features1.Solidity];
    values2 = [features2.Circularity, features2.Compactness, features2.Rectangularity, ...
              features2.Convexity, features2.Solidity];
    values3 = [features3.Circularity, features3.Compactness, features3.Rectangularity, ...
              features3.Convexity, features3.Solidity];
    
    figure;
    bar([values1; values2; values3]');
    set(gca, 'XTickLabel', feature_names);
    legend({'圆形', '矩形', '复杂形状'});
    title('形状特征比较');
    ylabel('特征值');
    grid on;
end