function out = PointDetection(img)

[h,w,L] = size(img);
out = zeros(h,w,L);

kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];

img = padarray(img,[1 1],'replicate','both');
img = double(img);

for k=1:L
    for i=1:h
        for j=1:w
            sumVal = 0;
            for x=1:3
                for y=1:3
                    sumVal = sumVal + img(i+x-1,j+y-1,k)*kernel(x,y);
                end
            end
            out(i,j,k) = sumVal;
        end
    end
end

out = uint8(mat2gray(out)*255);
end
