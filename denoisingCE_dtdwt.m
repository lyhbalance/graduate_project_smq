function y = denoisingCE_dtdwt(L1)
% Local Adaptive Image Denoising Algorithm
% Usage :
%        y = denoisingCE_dtdwt(x)
% INPUT :
%        x - a noisy image
% OUTPUT :
%        y - the corresponding denoised image

% Set the windowsize and the corresponding filter


% Number of Stages


% symmetric extension


    % run normaliz_coefcalc_dual_tree to generate this mat file.

% Forward dual-tree DWT
% Either FSfarras or AntonB function can be used to compute the stage 1 filters  
%[Faf, Fsf] = FSfarras;



% Noise variance estimation using robust median estimator..




% Contrast Enhancement

                
                    
                        

% The low-pass coefficients at the final decomposition level are optimised
% with the use of CLAHE
% for dir = 1:2
%     for dir1 = 1:2
% %         W{J+1}{dir}{dir1} = CHAHE(W{J+1}{dir}{dir1});
%         W{J+1}{dir}{dir1} = adapthisteq(W{J+1}{dir}{dir1} * 256 / max(max(W{J+1}{dir}{dir1})));
%     end
% end


% Extract the image
