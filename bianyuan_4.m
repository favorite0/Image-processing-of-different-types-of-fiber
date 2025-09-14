% Sobel 边缘检测
sobel_edges = edge(gray_img, 'sobel');
subplot(2,3,4);
imshow(sobel_edges);
title('Sobel 边缘检测');

% Canny 边缘检测
canny_edges = edge(gray_img, 'canny');
subplot(2,3,5);
imshow(canny_edges);
title('Canny 边缘检测');

% Prewitt 边缘检测
prewitt_edges = edge(gray_img, 'prewitt');
subplot(2,3,6);
imshow(prewitt_edges);
title('Prewitt 边缘检测');