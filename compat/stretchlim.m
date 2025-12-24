function [low, high] = stretchlim(I, tol)
%STRETCHLIM Find limits to contrast stretch an image
%   This is a compatibility function for older MATLAB versions
%   that don't have the Image Processing Toolbox

if nargin < 2
    tol = [0.01 0.99]; % default tolerance
end

% Convert to double if needed
if ~isa(I, 'double')
    I = im2double(I);
end

% For RGB images, process each channel separately
if ndims(I) == 3
    low = zeros(1, 3);
    high = ones(1, 3);
    for c = 1:3
        [low(c), high(c)] = compute_limits(I(:,:,c), tol);
    end
else
    [low, high] = compute_limits(I, tol);
end

% Ensure output is in range [0, 1]
low = max(0, min(1, low));
high = max(0, min(1, high));

% Make sure low <= high
if low >= high
    low = 0;
    high = 1;
end
end

function [low, high] = compute_limits(I, tol)
% Compute limits for a single channel

% Get histogram
[counts, binLocations] = imhist(I);

% Convert to CDF
cdf = cumsum(counts) / sum(counts);

% Find low and high limits
low_idx = find(cdf >= tol(1), 1, 'first');
high_idx = find(cdf >= tol(2), 1, 'first');

% Handle edge cases
if isempty(low_idx), low_idx = 1; end
if isempty(high_idx), high_idx = numel(binLocations); end

% Convert to intensity values
low = binLocations(low_idx);
high = binLocations(high_idx);

% Ensure we don't return exactly 0 or 1 to avoid issues
low = max(eps, low);
high = min(1-eps, high);
end
