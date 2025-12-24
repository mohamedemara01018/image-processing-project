function output = boundary_extraction(img, seSize)
% BOUNDARY_EXTRACTION - Extracts boundaries using morphological operations
% Boundary = Original - Erosion
%
% Syntax: output = boundary_extraction(img, seSize)
%
% Inputs:
%   img    - Input image (grayscale or RGB)
%   seSize - Size of structuring element (default: 1)

if nargin < 2 || isempty(seSize)
    seSize = 1;
end

% Convert to grayscale if RGB
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% Create structuring element (square shape for R2013a)
se = strel('square', 2*seSize+1);

% Apply erosion
eroded = imerode(grayImg, se);

% Extract boundary: original - eroded
output = imsubtract(grayImg, eroded);

end