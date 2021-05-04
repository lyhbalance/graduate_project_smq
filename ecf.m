function ecfw = ecf(Complex)

%  ecf is the sample estimate of empirical characteristic function 
% Complex is a wavelet coefficients matrix
I = sqrt(-1);
size1 = size(Complex);
ecfw = zeros(size1(1,1), size1(1,2));
omega = 4 * pi / 512;
B = Complex(1:2,1:2);
ecfw(1,1) = sum(sum(exp(I * omega * B))) / 4;
B = Complex(1:2,size1(1,2)-1:size1(1,2));
ecfw(1,size1(1,2)) = sum(sum(exp(I * omega * B))) / 4;
B = Complex(size1(1,1)-1:size1(1,1),1:2);
ecfw(size1(1,1),1) = sum(sum(exp(I * omega * B))) / 4;
B = Complex(size1(1,1)-1:size1(1,1),size1(1,2)-1:size1(1,2));
ecfw(size1(1,1),size1(1,2)) = sum(sum(exp(I * omega * B))) / 4;

for m = 2:size1(1,1)-1
    B = Complex(m-1:m+1,1:2);
    ecfw(m,1) = sum(sum(exp(I * omega * B))) / 6;
    B = Complex(m-1:m+1,size1(1,2)-1:size1(1,2));
    ecfw(m,size1(1,2)) = sum(sum(exp(I * omega * B))) / 6;
end
for n = 2:size1(1,2)-1
    B = Complex(1:2,n-1:n+1);
    ecfw(1,n) = sum(sum(exp(I * omega * B))) / 6;
    B = Complex(size1(1,1)-1:size1(1,1),n-1:n+1);
    ecfw(size1(1,1),n) = sum(sum(exp(I * omega * B))) / 6;
end

for m = 2:size1(1,1)-1
    for n = 2:size1(1,2)-1
        B = Complex(m-1:m+1,n-1:n+1);
        ecfw(m,n) = sum(sum(exp(I * omega * B))) / 9;
    end
end

    

