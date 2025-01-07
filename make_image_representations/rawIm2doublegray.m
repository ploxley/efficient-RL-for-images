function rawIm2doublegray(filename)

% Takes image "filename" and converts it to a double-precision, 
% grayscale, square output called "ImGDS_filename.txt".

% Read file "filename"
ImRaw = imread(filename);

% Make grayscale to deal with single channel instead of three
ImGray = rgb2gray(ImRaw);

% Make double precision for maths ops
ImGrayDouble = im2double(ImGray);

% Make image square for simple patch construction
L = min(size(ImGrayDouble)); 
ImGrayDoubleSquare = ImGrayDouble(1:L,1:L);		

% Write output image
[~,name,~] = fileparts(filename);
path = '../image_data/';
writematrix(ImGrayDoubleSquare,[path 'ImGDS_' name])