function Gabor_fns = make_Gabors(M, Gabor_pars)

% Constructs N Gabor functions using the N parameter values 
% given in the Gabor_pars array. Each Gabor function is a 
% vector of length M. 

N = length(Gabor_pars);
RN = sqrt(N);
RM = sqrt(M);
phi = reshape(Gabor_pars(1,:), RN, RN);
varphi = reshape(Gabor_pars(2,:), RN, RN);
sigma_x = reshape(Gabor_pars(3,:), RN, RN);
sigma_y = reshape(Gabor_pars(4,:), RN, RN);
k_wave = reshape(2*pi./Gabor_pars(5,:), RN, RN);
x0 = reshape(Gabor_pars(6,:), RN, RN);
y0 = reshape(Gabor_pars(7,:), RN, RN);
x = linspace(-0.5, 0.5, RM);
y = x;
norm = 0.2; 

for i = 1:RM
    for j = 1:RM
		for k = 1:RN
	    	for m = 1:RN
                rx = (x(i)-x0(k,m))*cos(phi(k,m))... 
                    - (y(j)-y0(k,m))*sin(phi(k,m));

                ry = (x(i)-x0(k,m))*sin(phi(k,m))... 
                    + (y(j)-y0(k,m))*cos(phi(k,m));

                exparg_x = rx/sigma_x(k,m);

                exparg_y = ry/sigma_y(k,m);

                Gabor_fns(i,j,k,m) = norm*exp(-0.5*(exparg_x^2 + exparg_y^2))...
                                     *cos(k_wave(k,m)*ry + varphi(k,m));
            end
        end
    end
end

Gabor_fns = reshape(Gabor_fns, M, N);
