% 直方图均衡化
eq_img = histeq(gray_img);
subplot(2,3,3);
imshow(eq_img);
title('直方图均衡化');

% 对比度调整
adj_img = imadjust(gray_img);
subplot(2,3,4);
imshow(adj_img);
title('对比度调整');

% 自适应直方图均衡化
adapthisteq_img = adapthisteq(gray_img);
subplot(2,3,5);
imshow(adapthisteq_img);
title('自适应直方图均衡化');