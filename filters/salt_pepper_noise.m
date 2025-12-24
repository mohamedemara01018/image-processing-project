function out = salt_pepper_noise(img, p)
% p in range [0.01, 0.2]

if nargin < 2
    p = 0.05;
end

p = max(0, min(0.2, p));

if ndims(img) == 3
    img = rgb2gray(img);
end

img = uint8(img);
out = img;

[M,N] = size(img);
r = rand(M,N);

out(r < p/2) = 0;
out(r >= p/2 & r < p) = 255;
end
