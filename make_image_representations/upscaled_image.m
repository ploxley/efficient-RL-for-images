function upscaled_image(filename)

% Takes square double-precicison grayscale image and 
% upscales it by a factor of four using bicubic interpolation.

% Read file "filename"
Grayscale = readmatrix(filename);
L = length(Grayscale);
sqrt_number_of_gabors = 2*L; % x4 overcomplete raw image
upscaled_image = imresize(Grayscale,sqrt_number_of_gabors/L);  

% Write output image
[~,name,~] = fileparts(filename);
path = '../image_data/';
writematrix(upscaled_image,[path 'OC_upscaled_' name])