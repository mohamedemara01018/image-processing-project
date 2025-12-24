function out = LineDetectionRobert(img)

[h,w,L] = size(img);
out = zeros(h,w,L);

Gx = [1 0; 0 -1];
Gy = [0 1; -1 0];

img = padarray(img,[1 1],'replicate','both');
img = double(img);

for k=1:L
    for i=1:h
        for j=1:w
            gx = img(i,j,k)*Gx(1,1) + img(i+1,j+1,k)*Gx(2,2);
            gy = img(i,j+1,k)*Gy(1,2) + img(i+1,j,k)*Gy(2,1);
            out(i,j,k) = sqrt(gx^2 + gy^2);
        end
    end
end

out = uint8(mat2gray(out)*255);
end
