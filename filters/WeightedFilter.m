function output = WeightedFilter(img, maskSize)
% WEIGHTEDFILTER - Applies weighted average filter
% Uses gaussian-like weights for smoothing
%
% Syntax: output = WeightedFilter(img, maskSize)
%
% Inputs:
%   img      - Input image (grayscale or RGB)
%   maskSize - Size of filter mask (default: 3)

if nargin < 2 || isempty(maskSize)
    maskSize = 3;
end

% Ensure odd size
if mod(maskSize, 2) == 0
    maskSize = maskSize + 1;
end

% Convert to double for processing
img = double(img);

% Create weighted mask (gaussian-like)
center = floor(maskSize/2) + 1;
mask = zeros(maskSize, maskSize);

for i = 1:maskSize
    for j = 1:maskSize
        dist = sqrt((i-center)^2 + (j-center)^2);
        mask(i,j) = exp(-dist^2 / (2*(maskSize/4)^2));
    end
end

% Normalize mask
mask = mask / sum(mask(:));

% Apply filter
if size(img, 3) == 3
    % Process each channel for color images
    output = zeros(size(img));
    for ch = 1:3
        output(:,:,ch) = applyMask(img(:,:,ch), mask);
    end
else
    % Process grayscale image
    output = applyMask(img, mask);
end

% Convert back to uint8
output = uint8(output);

end

function filtered = applyMask(img, mask)
% Apply convolution with mask
[rows, cols] = size(img);
maskSize = size(mask, 1);
pad = floor(maskSize/2);

% Pad image
padded = padarray(img, [pad pad], 'replicate');

% Initialize output
filtered = zeros(rows, cols);

% Apply convolution
for i = 1:rows
    for j = 1:cols
        region = padded(i:i+maskSize-1, j:j+maskSize-1);
        filtered(i,j) = sum(sum(region .* mask));
    end
end

end