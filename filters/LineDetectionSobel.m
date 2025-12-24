function out = LineDetectionSobel(img, dir)

[h,w,L] = size(img);
out = zeros(h,w,L);

switch dir
    case 1 % H
        kernel = [-1 -2 -1; 0 0 0; 1 2 1];
    case 2 % V
        kernel = [-1 0 1; -2 0 2; -1 0 1];
    case 3 % DL
        kernel = [0 -1 -2; 1 0 -1; 2 1 0];
    case 4 % DR
        kernel = [-2 -1 0; -1 0 1; 0 1 2];
end

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
