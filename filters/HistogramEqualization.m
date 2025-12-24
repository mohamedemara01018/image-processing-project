function output_image = HistogramEqualization(input_image)

    input_image = im2uint8(input_image);
    [rows, cols, channels] = size(input_image);
    L = 256;

    % ===== Grayscale Image =====
    if channels == 1
        img = input_image;
        image_hist = zeros(L, 1);

        for i = 1:rows
            for j = 1:cols
                intensity = img(i, j);
                image_hist(intensity + 1) = image_hist(intensity + 1) + 1;
            end
        end

        cdf = cumsum(image_hist);

        cdf_min = min(cdf(cdf > 0));

        transformation = round((cdf - cdf_min) / ...
            (rows*cols - cdf_min) * (L - 1));

        output_image = zeros(rows, cols);
        for i = 1:rows
            for j = 1:cols
                old_val = img(i, j);
                output_image(i, j) = transformation(old_val + 1);
            end
        end

        output_image = uint8(output_image);

    % ===== RGB Image =====
    else
        output_image = zeros(rows, cols, 3, 'uint8');
        for k = 1:3
            channel = input_image(:,:,k);
            output_image(:,:,k) = HistogramEqualization(channel);
        end
    end

end
