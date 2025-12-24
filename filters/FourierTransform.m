function out = FourierTransform(img)

img = im2double(img);
[h,w,L] = size(img);
out = zeros(h,w,L);

for k = 1:L
    % FFT
    F = fft2(img(:,:,k));

    % Shift zero-frequency to center
    F_shift = fftshift(F);

    % Magnitude spectrum
    mag = abs(F_shift);

    % Log transform for visibility
    mag = log(1 + mag);

    % Normalize
    mag = mat2gray(mag);

    out(:,:,k) = mag;
end

out = uint8(out * 255);
end
