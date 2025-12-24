function bin = RGB2Binary(rgb)

[h,w,~] = size(rgb);
rgb = double(rgb);
bin = zeros(h,w);

T = 127;

for i = 1:h
    for j = 1:w
        gray = 0.2989*rgb(i,j,1) + ...
               0.5870*rgb(i,j,2) + ...
               0.1140*rgb(i,j,3);

        if gray > T
            bin(i,j) = 1;
        else
            bin(i,j) = 0;
        end
    end
end
end
