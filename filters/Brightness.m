function out = brightness(img, intensity)
% BRIGHTNESS  Adjust image brightness using intensity offset
%
% intensity range: [-100 , +100]
%   > 0  -> brighter
%   < 0  -> darker
%
% Works for RGB and Grayscale images

% ================= INPUT VALIDATION =================
if nargin < 2
    error('Brightness filter requires intensity parameter');
end

if ~isnumeric(intensity)
    error('Intensity must be numeric');
end

% Clamp intensity to [-100, 100]
if intensity > 100
    intensity = 100;
elseif intensity < -100
    intensity = -100;
end

% ================= PROCESS =================
img = double(img);          % convert to double for math
img = img + intensity;      % intensity offset

% ================= CLIPPING =================
img(img > 255) = 255;
img(img < 0)   = 0;

% ================= OUTPUT =================
out = uint8(img);
end