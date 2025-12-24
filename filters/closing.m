function output = closing(img, seSize)
% CLOSING - Morphological closing filter
% Closing = Dilation followed by Erosion
% Fills small holes and smooths boundaries
%
% Syntax: output = closing(img, seSize)
%
% Inputs:
%   img    - Input image (grayscale or RGB)
%   seSize - Size of structuring element (default: 3)

if nargin < 2 || isempty(seSize)
    seSize = 3;
end

% Convert to grayscale if RGB
if size(img, 3) == 3
    grayImg = rgb2gray(img);
    isColor = true;
else
    grayImg = img;
    isColor = false;
end

% Create structuring element (square shape for older MATLAB)
se = strel('square', 2*seSize+1);

% Apply morphological closing
if isColor
    % Process each channel separately for color images
    output = zeros(size(img), 'like', img);
    for ch = 1:3
        output(:,:,ch) = imclose(img(:,:,ch), se);
    end
else
    output = imclose(grayImg, se);
end

end