function ecfw = ecf(Complex)

%  ecf is the sample estimate of empirical characteristic function 
%  omega = 2��k / K where k = 2, 3, 4 and K = 512
% Complex is a wavelet coefficients matrix
I = sqrt(-1);
size1 = size(Complex);
temp = zeros(size1(1,1), size1(1,2));
for k = 2:4
    omega = 2 * pi * k / 512;
    B = Complex(1:2,1:2);
    temp(1,1) = sum(sum(exp(I * omega * B))) / 4;
    B = Complex(1:2,size1(1,2)-1:size1(1,2));
    temp(1,size1(1,2)) = sum(sum(exp(I * omega * B))) / 4;
    B = Complex(size1(1,1)-1:size1(1,1),1:2);
    temp(size1(1,1),1) = sum(sum(exp(I * omega * B))) / 4;
    B = Complex(size1(1,1)-1:size1(1,1),size1(1,2)-1:size1(1,2));
    temp(size1(1,1),size1(1,2)) = sum(sum(exp(I * omega * B))) / 4;
    
    for m = 2:size1(1,1)-1
        B = Complex(m-1:m+1,1:2);
        temp(m,1) = sum(sum(exp(I * omega * B))) / 6;
        B = Complex(m-1:m+1,size1(1,2)-1:size1(1,2));
        temp(m,size1(1,2)) = sum(sum(exp(I * omega * B))) / 6;
    end
    for n = 2:size1(1,2)-1
        B = Complex(1:2,n-1:n+1);
        temp(1,n) = sum(sum(exp(I * omega * B))) / 6;
        B = Complex(size1(1,1)-1:size1(1,1),n-1:n+1);
        temp(size1(1,1),n) = sum(sum(exp(I * omega * B))) / 6;
    end
    
    for m = 2:size1(1,1)-1
        for n = 2:size1(1,2)-1
            B = Complex(m-1:m+1,n-1:n+1);
            temp(m,n) = sum(sum(exp(I * omega * B))) / 9;
        end
    end
end

ecfw = temp /3;
    

