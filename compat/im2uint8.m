function B = im2uint8(A)
% Minimal im2uint8 replacement

if isa(A, 'uint8')
    B = A;
    return;
end

if islogical(A)
    B = uint8(A) * 255;
    return;
end

if isa(A, 'uint16')
    B = uint8(round(double(A) * (255/65535)));
    return;
end

A = double(A);

% Assume A is either in [0,1] or arbitrary; normalize if outside range
if any(A(:) < 0) || any(A(:) > 1)
    A = mat2gray(A);
end

A(A < 0) = 0;
A(A > 1) = 1;
B = uint8(round(A * 255));

end
