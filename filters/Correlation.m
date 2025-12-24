function out = Correlation(img, w)

img = double(img);
[h,wid,L] = size(img);
pad = floor(w/2);
kernel = ones(w,w) / (w*w);
out = zeros(h,wid,L);

for k=1:L
    padded = padarray(img(:,:,k),[pad pad],'replicate');
    for i=1:h
        for j=1:wid
            region = padded(i:i+w-1, j:j+w-1);
            out(i,j,k) = sum(sum(region .* kernel));
        end
    end
end

out = uint8(out);
end
