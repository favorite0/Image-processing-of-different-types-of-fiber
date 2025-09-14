% 添加高斯噪声
noisy_img = imnoise(gray_img, 'gaussian', 0, 0.01);
figure;
subplot(1,2,1);
imshow(noisy_img);
title('添加高斯噪声');

% 去除噪声（使用维纳滤波）
denoised_img = wiener2(noisy_img, [5 5]);
subplot(1,2,2);
imshow(denoised_img);
title('维纳滤波去噪');