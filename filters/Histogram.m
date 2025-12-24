function Histogram(img)

img = uint8(img);
[h,w,L] = size(img);

if L == 1
    hist = zeros(256,1);
    for i=1:h
        for j=1:w
            val = img(i,j);
            hist(val+1) = hist(val+1) + 1;
        end
    end
    bar(0:255,hist); title('Gray Histogram');

else
    histR=zeros(256,1); histG=zeros(256,1); histB=zeros(256,1);
    for i=1:h
        for j=1:w
            histR(img(i,j,1)+1)=histR(img(i,j,1)+1)+1;
            histG(img(i,j,2)+1)=histG(img(i,j,2)+1)+1;
            histB(img(i,j,3)+1)=histB(img(i,j,3)+1)+1;
        end
    end
    figure;
    subplot(3,1,1), bar(0:255,histR), title('Red');
    subplot(3,1,2), bar(0:255,histG), title('Green');
    subplot(3,1,3), bar(0:255,histB), title('Blue');
end
end
