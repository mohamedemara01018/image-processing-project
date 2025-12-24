function out = contraststretching(img, r_min, r_max)
% CONTRASTSTRETCHING  Linear contrast stretching
%
% r_min, r_max range: [0 , 255]
% r_min < r_max
%
% Works for RGB and Grayscale images

% ================= INPUT VALIDATION =================
if nargin < 3
    error('ContrastStretching requires r_min and r_max');
end

if ~isnumeric(r_min) || ~isnumeric(r_max)
    error('r_min and r_max must be numeric');
end

% Clamp limits to [0, 255]
r_min = max(0, min(255, r_min));
r_max = max(0, min(255, r_max));

if r_min >= r_max
    error('r_min must be less than r_max');
end

% ================= PROCESS =================
img = double(img);

% Linear contrast stretching formula
out = (img - r_min) * (255 / (r_max - r_min));

% ================= CLIPPING =================
out(out > 255) = 255;
out(out < 0)   = 0;

% ================= OUTPUT =================
out = uint8(out);
end
