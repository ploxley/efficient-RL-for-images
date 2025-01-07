function sparse_codes(filename)

% Takes square double-precicison grayscale image and returns its
% overcomplete sparse code. Each column of the sparse code matrix
% corresponds to a particular Gabor function, and each row is its 
% contribution from a different image patch.

% Read file "filename"
Grayscale = readmatrix(filename);

% Extract image patches for processing statistics
L = length(Grayscale);
N = 237; % Must evenly divide L
M = L/N; % patch size 
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

% Make Gabor function basis
% Degree of overcompleteness: 2*M (x4), 4*M (x16), 8*M (x64) 
sqrt_number_of_gabors = 2*M;
output_filename = 'OC_Sparse_'; % 'OC_Sparse_', 'OOC_Sparse_', 'OOOC_Sparse_'
%W = gpuArray(make_Gabors(M^2, generate_samples(sqrt_number_of_gabors^2)));
W = make_Gabors(M^2, generate_samples(sqrt_number_of_gabors^2));
% To view resulting Gabor functions use: imagesc(reshape(W(:,1),M,M))

% Find sparse code using least squares
tol = 1e-6;
maxiter = 600;
for i = 1:N
    for j = 1:N
        this_patch = patches(i,j,:,:);
        [a, flag] = lsqr(W,this_patch(:),tol,maxiter);
        sparse_patches(i,j,:,:) = ...
            reshape(a,sqrt_number_of_gabors,sqrt_number_of_gabors);
    end
end

% Stitch patches back together to get image
for i = 1:N
    k = 1 + (i-1)*sqrt_number_of_gabors;
    for j = 1:N
        p = 1 + (j-1)*sqrt_number_of_gabors;
        Sparse_Image(k:k+sqrt_number_of_gabors-1,p:p+sqrt_number_of_gabors-1)...
            = sparse_patches(i,j,:,:);
    end
end

% To test sparse code properties:
% A = Sparse_Image(1,:); histogram(A) 
% B = Sparse_Image(2,:); histogram(B) 
% scatter(A(:),B(:)) 
% corr(A',B') 

% To decode sparse code and get back original image
% for p = 1:L/M
%     for q = 1:L/M
%         b = sparse_patches(p,q,:,:);
%         reconstructed_patch = W*b(:);		
%         reconstructed_patches(p,q,:,:) = reshape(reconstructed_patch, M, M);
%     end
% end
% reconstructed_image = zeros(L);
% k = 1;
% for p = 1:L/M
%     m = 1;
%     for q = 1:L/M
%         reconstructed_image(k:k+(M-1),m:m+(M-1)) = reconstructed_patches(p,q,:,:);
%         m = m + M;
%     end
%     k = k + M;
% end
% reconstruction_error = sum((reconstructed_image(:) - Grayscale(:)).^2)
% overcompleteness = (sqrt_number_of_gabors/M)^2
% figure(1); imagesc(reconstructed_image); colorbar 
% figure(2); imagesc(Grayscale); colorbar 
% figure(3); imagesc(Sparse_Image); colorbar;

% Write output image
[~,name,~] = fileparts(filename);
path = '../image_data/';
writematrix(Sparse_Image,[path output_filename name])