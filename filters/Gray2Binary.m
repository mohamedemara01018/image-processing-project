function out = Gray2Binary(img, T)
% GRAY2BINARY
% Convert grayscale image to binary using user-defined threshold
%
% T range: [0 , 255]
% Works for RGB and grayscale images
% Keeps only the largest connected component
% Output is uint8 (0 or 255)

% ================= INPUT VALIDATION =================
if nargin < 2
    error('Gray2Binary requires a threshold value');
end

if ~isnumeric(T)
    error('Threshold must be numeric');
end

% Clamp threshold to [0, 255]
if T < 0
    T = 0;
elseif T > 255
    T = 255;
end

% ================= STEP 1: Convert to Grayscale =================
if ndims(img) == 3
    img = rgb2gray(img);
end

% ================= STEP 2: Convert Image to Double =================
img = im2double(img);

% Convert threshold from [0,255] to [0,1]
T = T / 255;

% ================= STEP 3: Thresholding =================
bw = img > T;

% ================= STEP 4: Connected Components =================
[L, num] = bwlabel(bw);

% If no objects found, return binary image
if num == 0
    out = uint8(bw) * 255;
    return;
end

% ================= STEP 5: Keep Largest Component =================
stats = regionprops(L, 'Area');
areas = [stats.Area];
[~, idx] = max(areas);

out = (L == idx);

% ================= STEP 6: Convert to uint8 =================
out = uint8(out) * 255;
end
