function out = InverseFourierTransform(img)

img = im2double(img);
[h,w,L] = size(img);
out = zeros(h,w,L);

for k = 1:L
    % Forward FFT
    F = fft2(img(:,:,k));

    % Shift
    F_shift = fftshift(F);

    % Inverse shift
    F_ishift = ifftshift(F_shift);

    % Inverse FFT
    img_back = ifft2(F_ishift);

    % Take real part
    img_back = real(img_back);

    % Normalize
    img_back = mat2gray(img_back);

    out(:,:,k) = img_back;
end

out = uint8(out * 255);
end
