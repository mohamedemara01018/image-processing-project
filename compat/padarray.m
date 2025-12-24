function B = padarray(A, padsize, method, direction)
% Minimal padarray replacement (supports 'replicate' and symmetric padding on both sides)

if nargin < 2
    error('padarray:NotEnoughInputs', 'Not enough input arguments.');
end
if nargin < 3 || isempty(method)
    method = 0;
end
if nargin < 4 || isempty(direction)
    direction = 'both';
end

if numel(padsize) == 1
    padsize = [padsize padsize];
end
padsize = double(padsize(:).');
if numel(padsize) ~= 2
    error('padarray:Unsupported', 'This minimal padarray supports 2-D padding only.');
end

if ~ischar(direction)
    error('padarray:Unsupported', 'Direction must be a string.');
end
if ~strcmpi(direction, 'both')
    error('padarray:Unsupported', 'This minimal padarray supports direction ''both'' only.');
end

ph = padsize(1);
pw = padsize(2);

sz = size(A);
H = sz(1);
W = sz(2);

if ischar(method)
    if strcmpi(method, 'replicate')
        r = [ones(1, ph) 1:H H*ones(1, ph)];
        c = [ones(1, pw) 1:W W*ones(1, pw)];
        if ndims(A) == 2
            B = A(r, c);
        else
            B = A(r, c, :);
        end
        return;
    else
        error('padarray:Unsupported', 'This minimal padarray supports method ''replicate'' only.');
    end
else
    % constant padding
    B = repmat(cast(method, class(A)), H + 2*ph, W + 2*pw, sz(3:end));
    if ndims(A) == 2
        B(ph+1:ph+H, pw+1:pw+W) = A;
    else
        B(ph+1:ph+H, pw+1:pw+W, :) = A;
    end
end

end
