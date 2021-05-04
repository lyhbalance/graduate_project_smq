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
s = imread('dataset/00.jpg');
s = double(s);
N = 512;

% Noise variance
sigma_n = 20;
n = sigma_n*randn(N,N);

% Add noise 
x = s + n;

% Run local adaptive image denoising algorithm using dual-tree DWT. 
y = denoising_dtdwt(x);
y1 = uint8(floor(y));
imwrite(y1,'dataset/00dtdwt.jpg');
% Calculate the error 
err = s - y;

% Calculate the PSNR value
PSNR = 20 * log10(256/std(err(:)))