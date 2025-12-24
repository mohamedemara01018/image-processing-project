function out = uniform_noise(img, a, b, perc)

img = im2double(img);
[h,w,L] = size(img);
out = img;

numPixels = round(perc * h * w);

for k = 1:L
    for n = 1:numPixels
        i = randi(h);
        j = randi(w);
        noise = a + (b - a) * rand;
        out(i,j,k) = out(i,j,k) + noise;
    end
end

out = mat2gray(out);
out = uint8(out * 255);
end
