% Main function
% Usage :
%        main_dtdwt
% INPUT :
%        Raw Lena image
% OUTPUT :
%        PSNR value of the denoised image
%
% Load clean image
clear ; close all; clc;
X = imread('dataset/04.jpg');
[H, S, V] = rgb2hsv(X);
max1 = max(max(V));
min1 = min(min(V));
L1 = (V - min1) / (max1 - min1);

% Run local adaptive image denoising algorithm using dual-tree DWT. 
L2 = denoising_dtdwt(L1);

% post-processing
L0 = max(max(L2)) / (log2(max(max(L2)) + 1)) * log(L2 + 1);
% L0 = L0 - min(min(L0)) / (max(max(L0)) - min(min(L0)));
% HSV to RGB transform
T = cat(3, H, S, L0); 
Y = hsv2rgb(T); 
figure
imshow(X)
figure
imshow(Y)
saveas(gcf, 'dataset/test04', 'jpg')
% Calculate the PSNR value
% PSNR = 20*log10(256/std(err(:)))