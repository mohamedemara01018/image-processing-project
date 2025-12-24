function out = LOG(img)

img = im2double(img);
[h,w,L] = size(img);
out = zeros(h,w,L);
c = 1;

for i=1:h
    for j=1:w
        for k=1:L
            out(i,j,k) = c * log(1 + img(i,j,k));
        end
    end
end

out = out - min(out(:));
out = out / (max(out(:)) + eps);
out = im2uint8(out);

end