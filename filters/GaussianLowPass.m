function NI = GaussianLowPass(I, D0)

I = im2double(I);
[H, W, L] = size(I);

Hf = zeros(H, W);
cx = floor(W/2) + 1;
cy = floor(H/2) + 1;

for i = 1:H
    for j = 1:W
        D = sqrt((i - cy)^2 + (j - cx)^2);
        Hf(i,j) = exp(-(D^2) / (2*(D0^2)));
    end
end

NI = zeros(H,W,L);

for k = 1:L
    F = fftshift(fft2(I(:,:,k)));
    G = F .* Hf;
    img_back = ifft2(ifftshift(G));
    NI(:,:,k) = mat2gray(real(img_back));
end

NI = uint8(NI * 255);
end
