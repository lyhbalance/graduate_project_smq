function maxgama = getMaxgama(matrix)
% within a 3 �� 3 multiscale sliding window centred around each coefficient xj
%  compute the maximum dispersion in the current wavelet subband
maxgama = max(max(matrix));
    
