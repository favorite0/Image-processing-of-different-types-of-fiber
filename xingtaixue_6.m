% 创建结构元素
se = strel('disk', 3);

% 膨胀
dilated = imdilate(binary_global, se);
figure;
subplot(2,2,1);
imshow(dilated);
title('膨胀操作');

% 腐蚀
eroded = imerode(binary_global, se);
subplot(2,2,2);
imshow(eroded);
title('腐蚀操作');

% 开运算（先腐蚀后膨胀）
opened = imopen(binary_global, se);
subplot(2,2,3);
imshow(opened);
title('开运算');

% 闭运算（先膨胀后腐蚀）
closed = imclose(binary_global, se);
subplot(2,2,4);
imshow(closed);
title('闭运算');