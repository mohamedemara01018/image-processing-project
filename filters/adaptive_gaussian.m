function out = adaptive_gaussian(img, w, sigma)

if nargin < 2, w = 7; end
if nargin < 3, sigma = 2; end

if ndims(img) == 3
    img = rgb2gray(img);
end

img = double(img);
pad = floor(w/2);
padded = padarray(img,[pad pad],'replicate');

[X,Y] = meshgrid(-pad:pad, -pad:pad);
H = exp(-(X.^2 + Y.^2)/(2*sigma^2));
H = H / sum(H(:));

out = zeros(size(img));

for i = 1:size(img,1)
    for j = 1:size(img,2)
        region = padded(i:i+w-1, j:j+w-1);
        out(i,j) = sum(sum(region .* H));
    end
end

out = uint8(out);
end
