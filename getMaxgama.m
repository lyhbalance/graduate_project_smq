function maxgama = getMaxgama(matrix, m, n)
% within a 3 ¡Á 3 multiscale sliding window centred around each coefficient xj
%  compute the maximum dispersion in the current wavelet subband
size1 = size(matrix);
A = matrix(m-1:m+1,n-1:n+1);
maxgama = max(max(A));
    
