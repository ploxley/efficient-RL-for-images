function [sqrt_num_pixels, pixel_ranges] = ...
find_image_patches(image, key, fundImLen, RL)

% Extracts image patches from a square parent image, and returns
% the image patch sizes (in pixels) and coordinates.

% Check if image is square
image_length = length(image);
if (image_length ~= size(image,1) || image_length ~= size(image,2)) 
    ME = MException('MATLAB:badsize','Image not square!!'); throw(ME)
end

% Map states into keys
keySet = [];
for s = 1:RL.num_states
        keySet = [keySet; key(1,RL.S{s}{1},RL.S{s}{2})];
end

% Discretize parent image into image patches.
% The number of image patches is sqrt_num_image_patches^2, which
% satisfies the bound: sqrt_num_image_patches^2 >= RL.num_states.
sqrt_num_image_patches = ceil(sqrt(RL.num_states));
sqrt_OC = image_length/fundImLen; % Square root of degree of overcompleteness
a = 19; % raw image patch side-length (in pixels) : 19 (for 361) or 20 (for 400)
sqrt_num_pixels = sqrt_OC*a;
% Required invariant: 
% sqrt_num_image_patches*sqrt_num_pixels <= sqrt_OC*fundImLen
% simplifies to: sqrt_num_image_patches*a <= fundImLen
if (sqrt_num_image_patches*a > fundImLen)
    ME = MException('MATLAB:Too many states!!'); throw(ME)
end

% Create pixel coordinates for image patches
valueSet_temp = [];
for i = 1:sqrt_num_image_patches
    for j = 1:sqrt_num_image_patches
        valueSet_temp = [valueSet_temp;... 
            [sqrt_num_pixels*(i-1)+1, sqrt_num_pixels*i,...
            sqrt_num_pixels*(j-1)+1, sqrt_num_pixels*j]];
    end
end
    
% Keep only RL.num_states number of values
for i = 1:length(keySet)
    valueSet(i,:) = {valueSet_temp(i,:)};
end

pixel_ranges = containers.Map(keySet, valueSet);