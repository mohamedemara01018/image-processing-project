function out = LineSharpening(img, dir)

edges = LineDetectionSobel(img, dir);
out = double(img) + double(edges);
out = uint8(mat2gray(out)*255);

end
