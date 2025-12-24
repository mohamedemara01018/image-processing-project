function out = MeanFilter(img, mh, mw)

[h,w,L] = size(img);
out = zeros(h,w,L);
ph = floor(mh/2); pw = floor(mw/2);

img = padarray(img,[ph pw],'replicate','both');
img = double(img);

for k=1:L
    for i=1:h
        for j=1:w
            sumVal = 0;
            for x=1:mh
                for y=1:mw
                    sumVal = sumVal + img(i+x-1,j+y-1,k);
                end
            end
            out(i,j,k) = sumVal/(mh*mw);
        end
    end
end

out = uint8(out);
end
