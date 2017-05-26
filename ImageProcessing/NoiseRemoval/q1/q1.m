function q1()
salesman = imread('salesman.bmp');
kernel_size = 7;
pad_size = floor(kernel_size/2);
sz = size(salesman);
padded_salesman = zeros(sz(1)+pad_size*2, sz(2)+pad_size*2, 'double');
padded_salesman(pad_size+1:end-pad_size,pad_size+1:end-pad_size) = double(salesman);
figure;imshow(salesman);
high = max(padded_salesman(:));
low = min(padded_salesman(:));
figure;imshow(padded_salesman,[low high]);title('Original Salesman');

%% Convolution in Time Domain
avg_filter_kernel = (1/kernel_size^2)*ones(kernel_size,kernel_size);
output_image = convolve2d_time(padded_salesman, avg_filter_kernel);
high = max(output_image(:));
low = min(output_image(:));
figure;imshow(output_image,[low high]);title('Time Domain convolution');
size(output_image);


%% Convolution in Freq Domain

output_image_freq1 = convolve2d_freq1(salesman, avg_filter_kernel);
high = max(output_image_freq1(:));
low = min(output_image_freq1(:));
figure;imshow(output_image_freq1,[low high]);title('Freq Domain convolution 1');
output_image_freq1 = output_image_freq1(64+1:end-64,64+1:end-64);
figure;imshow(output_image_freq1,[low high]);title('Freq Domain Convolution 1 : Final 256x256');
size(output_image_freq1)
Y1a = round(output_image);
Y1b = round(output_image_freq1);

disp(['b): max difference from part (a): ' num2str(max(max(abs(Y1b-Y1a))))]);


%% Convolution in Freq Domain

output_image_freq2 = convolve2d_freq2(salesman, avg_filter_kernel);
high = max(output_image_freq2(:));
low = min(output_image_freq2(:));
figure;imshow(output_image_freq2,[low high]);title('Freq Domain convolution 2');
output_image_freq2 = output_image_freq2(128+1:end-128,128+1:end-128);
size(output_image_freq2)
Z1a = round(output_image);
Z1b = round(output_image_freq2);

disp(['c): max difference from part (a): ' num2str(max(max(abs(Z1b-Z1a))))]);

end


function output_image = convolve2d_time(input_image, filt_kernel)
sz = size(input_image);
sz_filt = size(filt_kernel);
pad = floor(sz_filt(1)/2);
output_image = zeros(sz(1)-2*pad, sz(2) - 2*pad);
for ix=1+pad:sz(1)-pad
    for jx=1+pad:sz(2)-pad
        patch = input_image(ix-pad:ix+pad,jx-pad:jx+pad);       
        output_image(ix-pad,jx-pad) = sum(patch(:).* filt_kernel(:));
    end 
end 
end


function output_image = convolve2d_freq(padded_salesman, avg_filter_kernel)
sz = size(padded_salesman);
szk = size(avg_filter_kernel);
szk_half = floor(szk(1)/2);
midpointx = floor(sz(1)/2) + 1;
midpointy = floor(sz(2)/2) + 1;
impulse_response = zeros(sz);
impulse_response(midpointx-szk_half:midpointx+szk_half,midpointx-szk_half:midpointy+szk_half) = avg_filter_kernel;
padded_salesman_freq = fft2(padded_salesman);
%padded_salesman_freq= fftshift(padded_salesman_freq);
impulse_response_freq = fft2(impulse_response);
output_image_freq = padded_salesman_freq .* impulse_response_freq;
output_image = ifft2(output_image_freq);
output_image  = ifftshift(output_image);
end

function output_image = convolve2d_freq1(salesman, avg_filter_kernel)
impulse_response = zeros(128,128);
impulse_response(62:68,62:68) = 1/49;
impulse_response_padded = zeros(128+256,128+256);
impulse_response_padded(1+128:end-128,1+128:end-128) = impulse_response;
figure;surf(ifftshift(ifft2(fftshift(impulse_response_padded))));title('zero padded impulse response');
freq_response = fft2(impulse_response_padded);

salesman_padded = zeros(128+256,128+256);
salesman_padded(64+1:end-64,64+1:end-64) = salesman;
figure;imshow(salesman_padded, [min(min(salesman_padded)) max(max(salesman_padded))]);title('zero padded original image');
freq_salesman= fft2(salesman_padded);
output_image_freq = freq_response .* freq_salesman;
output_image = ifft2(output_image_freq);
output_image  = ifftshift(output_image);

figure;surf(log(abs(fftshift(freq_salesman))));title('zero padded image log mag spectrum');
figure;surf(log(abs(fftshift(freq_response))));title('zero padded impulse response log mag spectrum');
figure;surf(log(abs(fftshift(output_image_freq))));title('zero padded output log mag spectrum');

end


function output_image = convolve2d_freq2(salesman, avg_filter_kernel)
impulse_response = zeros(256,256);
impulse_response(126:132,126:132) = 1/49;
figure;surf(impulse_response);title('Freq Domain 2: Freq Response');
figure;surf(ifftshift(ifft2(fftshift(impulse_response))));title('Freq Domain 2: Impulse Response');

impuse_response_padded = zeros(256+256,256+256);
impuse_response_padded(1+128:end-128,1+128:end-128) = impulse_response;
figure;surf(impuse_response_padded);title('Freq Domain 2: Freq Response Padded');
figure;surf(ifftshift(ifft2(fftshift(impuse_response_padded))));title('Freq Domain 2: Impulse Response Padded');


freq_response = fft2(impuse_response_padded);

salesman_padded = zeros(256+256,256+256);
salesman_padded(128+1:end-128,128+1:end-128) = salesman;
freq_salesman= fft2(salesman_padded);
output_image_freq = freq_response .* freq_salesman;
output_image = ifft2(output_image_freq);
output_image  = ifftshift(output_image);
end