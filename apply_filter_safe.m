function out = apply_filter_safe(name,img,param)

if ~isa(img,'double')
    img = im2double(img);
end

toGray = @(i) (size(i,3)==3).*RGB2Gray(i) + (size(i,3)~=3).*i;
odd = @(x) max(3,2*floor(x/2)+1);

try
    switch name
        case 'RGB2Gray'
            out = RGB2Gray(img);

        case 'RGB2Binary'
            out = RGB2Binary(img);

        case 'Gray2Binary'
            out = Gray2Binary(img);

        case 'Negative'
            out = Negative(img);

        case 'Brightness'
            out = Brightness(img, param>=8);

        case 'ContrastStretching'
            out = ContrastStretching(img);

        case 'HistogramEqualization'
            out = HistogramEqualization(img);

        case 'GammaCorrection'
            out = GammaCorrection(img, max(0.01,param/10));

        case 'adaptive_gaussian'
            out = adaptive_gaussian(img, odd(param));

        case 'adaptive_mean'
            out = adaptive_mean(img, 3, odd(param));

        case 'LineDetectionSobel'
            out = LineDetectionSobel(toGray(img),1);

        case 'LineDetectionRobert'
            out = LineDetectionRobert(toGray(img));

        case 'PointDetection'
            out = PointDetection(toGray(img));

        case 'LOG'
            out = LOG(toGray(img));

        case {'MeanFilter','MedianFilter','MinFilter','MaxFilter','MidPointFilter'}
            k = odd(param);
            out = feval(name,img,k,k);

        case 'WeightedFilter'
            out = WeightedFilter(img);

        case {'erosion','dilation','opening','closing','boundary_extraction'}
            bw = imbinarize(toGray(img));
            out = feval(name,bw,ones(odd(param)));

        case 'gaussian_noise'
            out = gaussian_noise(img,param/100,0,0.05);

        case 'salt_pepper_noise'
            out = salt_pepper_noise(img,param/200,param/200);

        case 'uniform_noise'
            out = uniform_noise(img,-param/200,param/200,0.05);

        case 'rayleigh_noise'
            out = rayleigh_noise(img,0,param/100);

        case 'FourierTransform'
            out = FourierTransform(img);

        case 'InverseFourierTransform'
            out = InverseFourierTransform(img);

        case 'GaussianLowPass'
            out = GaussianLowPass(img,param);

        case 'GaussianHighPass'
            out = GaussianHighPass(img,param);

        otherwise
            out = img;
    end
catch
    out = img;
end

out = im2uint8(mat2gray(out));
end
