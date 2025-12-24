function out = dilation(img, se_size)
% DILATION - Morphological dilation from scratch
if nargin < 2, se_size = 3; end
if size(img, 3) == 3, img = rgb2gray(img); end

% Convert to double for processing
img = double(img);

% Create circular structuring element
se = createDiskSE(se_size);
[se_h, se_w] = size(se);
pad_h = floor(se_h/2);
pad_w = floor(se_w/2);

% Pad image
[h, w] = size(img);
padded = zeros(h + 2*pad_h, w + 2*pad_w);
padded(pad_h+1:pad_h+h, pad_w+1:pad_w+w) = img;

% Perform dilation
out = zeros(h, w);
for i = 1:h
    for j = 1:w
        % Extract region
        region = padded(i:i+se_h-1, j:j+se_w-1);
        % Apply structuring element and take max
        out(i,j) = max(max(region .* se));
    end
end

out = uint8(out);
end

function se = createDiskSE(radius)
% Create circular structuring element
if radius < 1, radius = 1; end
radius = round(radius);

diameter = 2 * radius + 1;
se = zeros(diameter, diameter);
center = radius + 1;

for i = 1:diameter
    for j = 1:diameter
        dist = sqrt((i - center)^2 + (j - center)^2);
        if dist <= radius
            se(i, j) = 1;
        end
    end
end
end