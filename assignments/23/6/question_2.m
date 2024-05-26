#!/usr/bin/octave -qf

image = imread('Lena.png');

brighten = [0, 0, 0; 0, 2, 0; 0, 0, 0];
darken = [0, 0, 0; 0, 0.5, 0; 0, 0, 0];
box_blur = [1, 1, 1; 1, 1, 1; 1, 1, 1] / 9;
gaussian_blur_3x3 = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 16;
gaussian_blur_5x5 = [1, 4, 6, 4, 1; 4, 16, 24, 16, 4; 6, 24, 36, 24, 6; 4, 16, 24, 16, 4; 1, 4, 6, 4, 1] / 256;
unsharp_masking_5x5 = [1, 4, 6, 4, 1; 4, 16, 24, 16, 4; 6, 24, -476, 24, 6; 4, 16, 24, 16, 4; 1, 4, 6, 4, 1] / -256;
sharpen = [0, -1, 0; -1, 5, -1; 0, -1, 0];
outline = [-1, -1, -1; -1, 8, -1; -1, -1, -1];

function[output] = convolution(image, kernel)
    [row, col] = size(image);
    [k_row, k_col] = size(kernel);

    delta = (k_row - 1) / 2;
    
    padded_image = zeros(row + 2 * delta, col + 2 * delta);
    padded_image(delta + 1:row + delta, delta + 1:col + delta) = image;

    output = zeros(row, col);

    for i = 1+delta:col+delta
        for j = 1+delta:row+delta
            sub_matrix = padded_image(i-delta:i+delta, j-delta:j+delta);
            output(i-delta, j-delta) = sum(sum(sub_matrix .* kernel));
        end
    end
    output = uint8(output);
end

brightened_image = convolution(image, brighten);
darkened_image = convolution(image, darken);
box_blurred_image = convolution(image, box_blur);
gaussian_blurred_3x3_image = convolution(image, gaussian_blur_3x3);
gaussian_blurred_5x5_image = convolution(image, gaussian_blur_5x5);
unsharp_masking_5x5_image = convolution(image, unsharp_masking_5x5);
sharpened_image = convolution(image, sharpen);
outlined_image = convolution(image, outline);

imwrite(brightened_image, 'brightened_image.png');
imwrite(darkened_image, 'darkened_image.png');
imwrite(box_blurred_image, 'box_blurred_image.png');
imwrite(gaussian_blurred_3x3_image, 'gaussian_blurred_3x3_image.png');
imwrite(gaussian_blurred_5x5_image, 'gaussian_blurred_5x5_image.png');
imwrite(unsharp_masking_5x5_image, 'unsharp_masking_5x5_image.png');
imwrite(sharpened_image, 'sharpened_image.png');
imwrite(outlined_image, 'outlined_image.png');

noised_image = imread('Noisy_Lena.png');

t0 = convolution(noised_image, gaussian_blur_5x5);
imwrite(t0, 'gaussian_blur_denoised_image.png');

t1 = convolution(noised_image, outline);
t1 = convolution(t1, box_blur);
inverse_t1 = 255 - t1;
t1 = (noised_image - t1 / 5 + inverse_t1 / 12);
imwrite(t1, 'outline_method_denoised_image.png');

[row, col] = size(noised_image);

F = fft2(double(noised_image));
F_shift = fftshift(F);

mask = zeros(row, col);
center = [row/2, col/2];
D0 = 37; % cutoff frequency
for i = 1:row
    for j = 1:col
        dist = sqrt((i-center(1))^2 + (j-center(2))^2);
        mask(i, j) = exp(-(dist^2) / (2*(D0^2)));
    end
end

F_shift = F_shift .* mask;

F = ifftshift(F_shift);

noised_image_denoised = ifft2(F);
noised_image_denoised = real(noised_image_denoised);

imwrite(uint8(noised_image_denoised), 'fft_denoised_image.png');
