function gama =  getGama(J, Complex, sigma)
%  Complex = Xj ,   j range in (1,J)
omega = 4 * pi / 512;
for i = 1:J-1
    size1 = size(Complex{i}{1}{1});
    for dir = 1:2
        for dir1 = 1:3
            ecfw = ecf(Complex{i}{dir}{dir1});
            gama{i}{dir}{dir1} =  abs(- (log(ecfw.^2) + power(sigma,2) * power(omega,2)) / 2 / omega);
        end
    end
end