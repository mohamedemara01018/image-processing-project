function gray = RGB2Gray(rgb)

[h,w,~] = size(rgb);
rgb = double(rgb);
gray = zeros(h,w);

for i = 1:h
    for j = 1:w
        R = rgb(i,j,1);
        G = rgb(i,j,2);
        B = rgb(i,j,3);

        gray(i,j) = 0.2989*R + 0.5870*G + 0.1140*B;
    end
end

gray = uint8(gray);
end
