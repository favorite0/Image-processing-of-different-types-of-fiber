% 全局阈值二值化
global_thresh = graythresh(gray_img);
binary_global = imbinarize(gray_img, global_thresh);
figure;
subplot(1,2,1);
imshow(binary_global);
title('全局阈值二值化');

% 自适应阈值二值化
binary_adaptive = imbinarize(gray_img, 'adaptive');
subplot(1,2,2);
imshow(binary_adaptive);
title('自适应阈值二值化');