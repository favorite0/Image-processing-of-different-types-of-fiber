% 高斯滤波
gaussian_filtered = imgaussfilt(gray_img, 2);
figure;
subplot(2,3,1);
imshow(gaussian_filtered);
title('高斯滤波');

% 中值滤波（去除椒盐噪声）
median_filtered = medfilt2(gray_img, [3 3]);
subplot(2,3,2);
imshow(median_filtered);
title('中值滤波');

% 均值滤波
mean_filtered = imfilter(gray_img, fspecial('average', [3 3]));
subplot(2,3,3);
imshow(mean_filtered);
title('均值滤波');