function processed_img = preprocess_image(image_path)
    % 读取图像
    img = imread('D:\工作\论文\小论文\在投论文\EAAI\MATLAB\部分数据集\扩大裁剪1\k1-b1.jpg');
    
    % 转换为灰度图像
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    
    % 直方图均衡化
    eq_img = histeq(gray_img);
    
    % 中值滤波去噪
    filtered_img = medfilt2(eq_img, [3 3]);
    
    % 自适应阈值二值化
    binary_img = imbinarize(filtered_img, 'adaptive');
    
    % 形态学操作去除小噪点
    se = strel('disk', 2);
    cleaned_img = imopen(binary_img, se);
    
    processed_img = cleaned_img;
end