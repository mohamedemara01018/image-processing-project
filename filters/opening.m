function out = opening(img, se)

temp = erosion(img, se);
out  = dilation(temp, se);

end