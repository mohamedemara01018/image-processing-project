function out = adaptive_mean(img, w)

if nargin < 2
    w = 5;
end

if mod(w,2)==0 || w < 1
    error('Window size must be odd');
end

if ndims(img) == 3
    img = rgb2gray(img);
end

img = double(img);
pad = floor(w/2);
padded = padarray(img,[pad pad],'replicate');

out = zeros(size(img));

for i = 1:size(img,1)
    for j = 1:size(img,2)
        region = padded(i:i+w-1, j:j+w-1);
        out(i,j) = mean(region(:));
    end
end

out = uint8(out);
end
