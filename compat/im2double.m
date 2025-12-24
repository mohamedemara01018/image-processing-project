function B = im2double(A)
% Minimal im2double replacement

if isfloat(A)
    B = double(A);
    return;
end

if islogical(A)
    B = double(A);
    return;
end

cls = class(A);
switch cls
    case 'uint8'
        B = double(A) / 255;
    case 'uint16'
        B = double(A) / 65535;
    case 'int8'
        B = (double(A) + 128) / 255;
    case 'int16'
        B = (double(A) + 32768) / 65535;
    otherwise
        B = double(A);
end

B(B < 0) = 0;
B(B > 1) = 1;

end
