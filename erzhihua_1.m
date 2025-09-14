% 读取图像
img = imread('D:\工作\MATLAB\部分数据集\扩大裁剪1\k1-b1.jpg');

% 显示原始图像
figure;
subplot(2,3,1);
imshow(img);
title('原始图像');

% 转换为灰度图像
if size(img, 3) == 3
    gray_img = rgb2gray(img);
    subplot(2,3,2);
    imshow(gray_img);
    title('灰度图像');
end