% Convert a natural image to an image representation.
% (see README.md for instructions)
% Possibilities include: 1. double precision grayscale (raw) image
%                        2. overcomplete raw image
%                        3. whitened image 
%                        4. overcomplete sparse code 
%                           (edit sparse_codes.m for degree of overcompleteness)

% Uncomment and run each code block as necessary

% % 1. Double precision grayscale (raw) image
% path = '../image_data/';
% files = [path '/*.ppm'];
% files_struct = dir(files);
% for i = 1:length(files_struct)
%     rawIm2doublegray([path '/' files_struct(i).name]);
% end

% % 2. Overcomplete raw image
% path = '../image_data/';
% files = [path '/ImGDS*'];
% files_struct = dir(files);
% for i = 1:length(files_struct)
%     upscaled_image([path '/' files_struct(i).name]);
% end

% % 3. Whitened image 
% path = '../image_data/';
% files = [path '/ImGDS*'];
% files_struct = dir(files);
% for i = 1:length(files_struct)
%     whiten([path '/' files_struct(i).name]);
% end

% % 4. Overcomplete sparse code
% path = '../image_data/';
% files = [path '/ImGDS*'];
% files_struct = dir(files);
% for i = 1:length(files_struct)
%     sparse_codes([path '/' files_struct(i).name]);
% end




