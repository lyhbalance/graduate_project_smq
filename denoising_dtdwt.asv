function y = denoising_dtdwt(L1)
% Local Adaptive Image Denoising Algorithm
% Usage :
%        y = denoising_dtdwt(x)
% INPUT :
%        x - a noisy image
% OUTPUT :
%        y - the corresponding denoised image

% Set the windowsize and the corresponding filter
windowsize  = 3;
windowfilt = ones(1,windowsize)/windowsize;

% Number of Stages
J = floor(log2(min(size(L1, 1), size(L1, 2)))) - 4;
I=sqrt(-1);

% symmetric extension
L = length(L1); % length of the original image.
N = L+2^J;     % length after extension.
L1 = symextend(L1,2^(J-1));

load nor_dualtree    % run normaliz_coefcalc_dual_tree to generate this mat file.

% Forward dual-tree DWT
% Either FSfarras or AntonB function can be used to compute the stage 1 filters  
%[Faf, Fsf] = FSfarras;
[Faf, Fsf] = AntonB;
[af, sf] = dualfilt1;
W0 = cplxdual2D(L1, J, Faf, af);
W = normcoef(W0,J,nor);


% Noise variance estimation using robust median estimator..
tmp = W{1}{1}{1}{1};
Nsig = median(abs(tmp(:)))/0.6745;

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

% Contrast Enhancement
sigma = 1.4826 * mad(Complex{1}{1}{1}(:));
gama = getGama(J, Complex, sigma);
for i = 1:J
    fprintf('in %d level\n',i);
    size1 = size(W0{i}{1}{1}{1});
    for dir = 1:2
        for dir1 = 1:3
            for m = 2:size1(1,1)-1
                for n = 2:size1(1,2)-1
                     C = getMaxgama(gama{i}{dir}{dir1}, m, n) / gama{i}{dir}{dir1}(m,n);
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
                
                    
                        

% The low-pass coefficients at the final decomposition level are optimised
% with the use of CLAHE
% for dir = 1:2
%     for dir1 = 1:2
% %         W{J+1}{dir}{dir1} = CHAHE(W{J+1}{dir}{dir1});
%         W{J+1}{dir}{dir1} = adapthisteq(W{J+1}{dir}{dir1} * 256 / max(max(W{J+1}{dir}{dir1})));
%     end
% end

y = icplxdual2D(W, J, Fsf, sf);

% Extract the image
ind = 2^(J-1)+1:2^(J-1)+L;
y = y(ind,ind);