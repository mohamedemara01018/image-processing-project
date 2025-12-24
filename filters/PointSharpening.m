function out = PointSharpening(img)

edges = PointDetection(img);
out = double(img) + double(edges);
out = uint8(mat2gray(out)*255);

end
