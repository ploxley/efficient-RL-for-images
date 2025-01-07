function whiten(filename)

% Takes square double-precicison grayscale image and "whitens" it
% by making use of its image patch statistics.

% Read file "filename"
Grayscale = readmatrix(filename);

% Extract image patches for processing statistics
L = length(Grayscale);
N = 237; % Must evenly divide L
M = L/N;
if ~(M == floor(M))
    ME = MException('MATLAB:badvalue','Bad value for number_of_patches!!'); 
    throw(ME) 
end
for i = 1:N
    k = 1 + (i-1)*M;
    for j = 1:N
        p = 1 + (j-1)*M;
        patches(i,j,:,:) = Grayscale(k:k+M-1,p:p+M-1);
    end
end
patches = reshape(patches,N^2,M^2);

% Remove mean from each patch
patches = patches - mean(patches);

% Find covariance matrix
S = cov(patches);

% Diagonalize covariance matrix
[U,D] = eig(S);

% Apply whitening transform 
whitened_patches = patches*U*D^(-1/2)*U';

% Tests
% mean(whitened_patches(:,1))
% cov(whitened_patches(:,1),whitened_patches(:,2))

% Stitch whitened patches back together to get whitened image
whitened_patches = reshape(whitened_patches,N,N,M,M);
for i = 1:N
    k = 1 + (i-1)*M;
    for j = 1:N
        p = 1 + (j-1)*M;
        Whitened_Image(k:k+M-1,p:p+M-1) = whitened_patches(i,j,:,:);
    end
end

% Write output image
[~,name,~] = fileparts(filename);
path = '../image_data/';
writematrix(Whitened_Image,[path 'Whitened_' name])