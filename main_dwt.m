% Main function
% Usage :
%        main
% INPUT :
%        Raw Lena image
% OUTPUT :
%        PSNR value of the denoised image
%
% Load clean image
s = imread('dataset/00.jpg');
s = double(s);
N = 512;

% Noise variance
sigma_n = 20;
n = sigma_n*randn(N);

% Add noise 
x = s + n;
x1 = uint8(floor(x));
imwrite(x1,'dataset/00noise.jpg');
% Run local adaptive image denoising algorithm
y = denoising_dwt(x);
y1 = uint8(floor(y));
imwrite(y1,'dataset/00dwt.jpg');
% Calculate the error 
err = s - y;

% Calculate the PSNR value
PSNR = 20*log10(256/std(err(:)))