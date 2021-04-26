function gama =  getGama(J, Complex, sigma)
%  x = 2��k / K where k = 2, 3, 4 and K = 512
%  Complex = Xj ,   j range in (1,J)
for i = 1:J
    size1 = size(Complex{i}{1}{1});
    tgama = zeros(size1(1,1),size1(1,2));
    for dir = 1:2
        for dir1 = 1:3
            for k = 2:4
                omega = 2 * pi * k / 512;
                ecfw = ecf(Complex{i}{dir}{dir1});
                tgama = tgama - (log(ecfw.^2) - power(sigma,2) * power(omega,2)) / 2 / omega;
            end
            gama{i}{dir}{dir1} = (tgama) / 3;
        end
    end
end
% gama{J}{1}{1}