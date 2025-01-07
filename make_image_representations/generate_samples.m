function Gabor_pars = generate_samples(N)

% Generates N random samples for each Gabor function parameter.

% Added for reproducibility
rng(2,'twister');

% Model parameter values (taken from 10.1162/neco_a_00997)
alpha1 = 1.51;
beta1 = 0.13; 	% 0.13 -orientation res, 0.095 -unit aspect ratio
alpha2 = 1.66;
beta2 = 0.068; 	% 0.068 -orientation res, 0.103 -unit aspect ratio
alpha3 = 2.81;
beta3 = 0.195;
rho = 1.25;

% Generate samples for sigma_x, sigma_y, and lambda
Z = randn(1,N);
W = [1 1 rho];
X = W'*Z; 
invpcdf = @(x, alpha, beta) beta.*(1-x).^(-1/alpha);
sigma_x = invpcdf(normcdf(X(1,:)), alpha1, beta1);
sigma_y = invpcdf(normcdf(X(2,:)), alpha2, beta2);
lambda = invpcdf(normcdf(X(3,:)), alpha3, beta3);

% Generate N samples for phi, varphi, x0 and y0
phi = 2*pi*rand(1,N);
varphi = pi*rand(1,N);
x0 = -0.5 + rand(1,N);
y0 = -0.5 + rand(1,N);

Gabor_pars = [phi; varphi; sigma_x; sigma_y; lambda; x0; y0];
