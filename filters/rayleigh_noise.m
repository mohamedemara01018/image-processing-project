function out = rayleigh_noise(img, a, b)

img = im2double(img);
[h,w,L] = size(img);
out = img;

for k = 1:L
    for i = 1:h
        for j = 1:w
            r = rand;
            noise = a + sqrt(-b * log(1 - r));
            out(i,j,k) = out(i,j,k) + noise;
        end
    end
end

out = mat2gray(out);
out = uint8(out * 255);
end
