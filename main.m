clear ; close all; clc;
X = imread('dataset/church.png');
[H, S, V] = rgb2hsv(X);
max1 = max(max(V));
min1 = min(min(V));
L1 = (V - min1) / (max1 - min1);


% Run local adaptive image denoising algorithm using dual-tree DWT. 
windowsize  = 7;
windowfilt = ones(1,windowsize)/windowsize;
J = floor(log2(min(size(L1, 1), size(L1, 2)))) - 4;
I=sqrt(-1);
L = length(L1); % length of the original image.
N = L+2^J;     % length after extension.
L1 = symextend(L1,2^(J-1));
load nor_dualtree;
[Faf, Fsf] = AntonB;
[af, sf] = dualfilt1;
W0 = cplxdual2D(L1, J, Faf, af);
W = normcoef(W0,J,nor);
Nsig = median(abs(W{1}{1}{1}{1}(:)))/0.6745;
for scale = 1:J-1
    for dir = 1:2
        for dir1 = 1:3
            % Noisy complex coefficients
            %Real part
            Y_coef_real = W{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = W{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = W{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = W{scale+1}{2}{dir}{dir1};
            % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
            Y_parent_real  = expand(Y_parent_real);
            Y_parent_imag   = expand(Y_parent_imag);
            
            % Signal variance estimation
            Wsig = conv2(windowfilt,windowfilt,(Y_coef_real).^2,'same');
            
            Ssig = sqrt(max(Wsig-Nsig.^2,eps));
            
            % Threshold value estimation
            T = sqrt(3)*Nsig^2./Ssig;
            
            % Bivariate Shrinkage
            Y_coef = Y_coef_real+I*Y_coef_imag;
            Y_parent = Y_parent_real + I*Y_parent_imag;
            Y_coef = bishrink(Y_coef,Y_parent,T);
            W{scale}{1}{dir}{dir1} = real(Y_coef);
            W{scale}{2}{dir}{dir1} = imag(Y_coef);
            
            %
            Complex{scale}{dir}{dir1} = W0{scale}{1}{dir}{dir1} + I*W0{scale}{2}{dir}{dir1};
        end
    end
end

% Inverse Transform
W = unnormcoef(W,J,nor);

for dir = 1:2
    for dir1 = 1:3
        Complex{J}{dir}{dir1} = W0{J}{1}{dir}{dir1} + I*W0{J}{2}{dir}{dir1};
    end
end
gama = getGama(J, Complex, Nsig);
for i = 1:J-1
    fprintf('in %d level\n',i);
    size1 = size(W0{i}{1}{1}{1});
    for dir = 1:2
        for dir1 = 1:3
            max1 = getMaxgama(gama{i}{dir}{dir1});
            for m = 2:size1(1,1)-1
                for n = 2:size1(1,2)-1
                     C = max1 / gama{i}{dir}{dir1}(m,n);
                     Ac= exp(-1 / C) + 1 - exp(-1);
                    for dir = 1:2
                        for dir1 = 1:3
                            W{i}{1}{dir}{dir1}(m,n) = W{i}{1}{dir}{dir1}(m,n) * Ac;
                            W{i}{2}{dir}{dir1}(m,n) = W{i}{2}{dir}{dir1}(m,n) * Ac;
                        end
                    end
                end
            end
        end
    end
end
% for dir = 1:2
%     for dir1 = 1:2
%         W{J+1}{dir}{dir1} = adapthisteq(W{J+1}{dir1}{dir1},'ClipLimit',0.03);
%     end
% end
W{J+1}{1}{1} = adapthisteq(W{J+1}{1}{1},'ClipLimit',0.03);
y = icplxdual2D(W, J, Fsf, sf);
ind = 2^(J-1)+1:2^(J-1)+L;
L2 = y(ind,ind);


% post-processing
L0 = max(max(L2)) / (log2(max(max(L2)) + 1)) * log(abs(L2) + 1);
% L0 = (L2 - min(min(L2)))/(max(max(L2))- min(min(L2)));
% HSV to RGB transform
T = cat(3, H, S, L0); 
Y = hsv2rgb(T); 
figure
imshow(X)
figure
imshow(Y)
saveas(gcf, 'dataset/churchtest', 'png')