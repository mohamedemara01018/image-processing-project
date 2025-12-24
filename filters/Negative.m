function out = Negative(img)

[h,w,L] = size(img);
out = zeros(h,w,L);

for i=1:h
    for j=1:w
        for k=1:L
            out(i,j,k) = 255 - img(i,j,k);
        end
    end
end

out = uint8(out);
end
