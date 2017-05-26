
%% PART A

im0file=fopen('girl2.bin');
x0=fread(im0file,inf,'uint8');
im0=reshape(x0,256,256)';
figure;
subplot(3,4,1);imshow(im0,[min(im0(:)) max(im0(:))]); title('Original');

im1file=fopen('girl2Noise32.bin');
x1=fread(im1file,inf,'uint8');
im1=reshape(x1,256,256)';
subplot(3,4,5);imshow(im1,[min(im1(:)) max(im1(:))]);title('Broadband Noise');

im1file=fopen('girl2Noise32Hi.bin');
x1=fread(im1file,inf,'uint8');
im2=reshape(x1,256,256)';
subplot(3,4,9);imshow(im2,[min(im2(:)) max(im2(:))]);title('Hi-Pass Noise');

mse1_orig = sum(sum(sum((double(im1) - double(im0)).^2)))/numel(im0);
mse2_orig = sum(sum(sum((double(im2) - double(im0)).^2)))/numel(im0);
sig_orig =  sum(sum(sum((double(im0)).^2)))/numel(im0);

snr1_orig = 10*log(sig_orig/mse1_orig);
snr2_orig = 10*log(sig_orig/mse2_orig);
fprintf('************************* PART A START ****************************************\n');
fprintf('Broadband Gaussian Corrupted and Original Image MSE = %f SNR = %f\n', mse1_orig, snr1_orig);
fprintf('High Pass Gaussian Corrupted and Original Image MSE = %f SNR = %f\n', mse2_orig, snr2_orig);
fprintf('************************* PART A END  *****************************************\n\n');

%% PART B

U_cutoff = 64;
[U,V] = meshgrid(-128:127,-128:127);
HLtildeCenter = double(sqrt(U.^2 + V.^2) <= U_cutoff);
HLtilde = fftshift(HLtildeCenter);

fim0 = (fft2(im0));
fim1 = (fft2(im1));
fim2 = (fft2(im2));

fim0Htilde = fim0 .* HLtilde;
fim1Htilde = fim1 .* HLtilde;
fim2Htilde = fim2 .* HLtilde;

filt_im0 = ifft2(fim0Htilde);
filt_im1 = ifft2(fim1Htilde);
filt_im2 = ifft2(fim2Htilde);

 
subplot(3,4,2);imshow(filt_im0,[min(filt_im0(:)) max(filt_im0(:))]);title('Original. Ideal Lowpass 64');
subplot(3,4,6);imshow(filt_im0,[min(filt_im1(:)) max(filt_im1(:))]);title('Broadband noise. Ideal Lowpass 64');
subplot(3,4,10);imshow(filt_im0,[min(filt_im2(:)) max(filt_im2(:))]);title('Hi Pass noise. Ideal Lowpass 64');


mse0_64cutoff = sum(sum(sum((double(filt_im0) - double(im0)).^2)))/numel(im0);
mse1_64cutoff = sum(sum(sum((double(filt_im1) - double(im0)).^2)))/numel(im0);
mse2_64cutoff = sum(sum(sum((double(filt_im2) - double(im0)).^2)))/numel(im0);

snr0_64cutoff = 10*log(sig_orig/mse0_64cutoff);
snr1_64cutoff = 10*log(sig_orig/mse1_64cutoff);
snr2_64cutoff = 10*log(sig_orig/mse2_64cutoff);

isnr1 = snr1_64cutoff - snr1_orig;
isnr2 = snr2_64cutoff - snr2_orig;

fprintf('************************* PART B START ****************************************\n');
fprintf('Original Filtered and Original Image MSE1 = %f SNR = %f\n', mse0_64cutoff, snr0_64cutoff);
fprintf('Broadband Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse1_64cutoff, snr1_64cutoff, isnr1);
fprintf('High Pass Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse2_64cutoff, snr2_64cutoff, isnr2);
fprintf('************************* PART B END   ****************************************\n\n');


%% PART C

U_cutoff_H = 64;
SigmaH = 0.19 * 256 / U_cutoff_H;
[U,V] = meshgrid(-128:127,-128:127);
HtildeCenter = exp((-2*pi*SigmaH^2)/(256.^2)*(U.^2 + V.^2));
Htilde = fftshift(HtildeCenter);
H = ifft2(Htilde);
H2 = fftshift(H);
ZPH2 = zeros(512,512);
ZPH2(1:256,1:256) = H2;
freq_ZPH2 = fft2(ZPH2);
% freq_ZPH2 = fftshift(freq_ZPH2);


pad = 128;
im0pad512 = zeros(512,512);
im1pad512 = zeros(512,512);
im2pad512 = zeros(512,512);
im0pad512(pad+1:end-pad,pad+1:end-pad) = im0;
im1pad512(pad+1:end-pad,pad+1:end-pad) = im1;
im2pad512(pad+1:end-pad,pad+1:end-pad) = im2;
f_im0pad512 = fft2(im0pad512);
f_im1pad512 = fft2(im1pad512);
f_im2pad512 = fft2(im2pad512);
% 
% f_im0pad512 = fftshift(f_im0pad512);
% f_im0pad512 = fftshift(f_im0pad512);
% f_im0pad512 = fftshift(f_im0pad512);


freq_conv0=f_im0pad512 .* freq_ZPH2;
freq_conv1=f_im1pad512 .* freq_ZPH2;
freq_conv2=f_im2pad512 .* freq_ZPH2;

im0_conv = (real(ifft2((freq_conv0))));
im1_conv = (real(ifft2((freq_conv1))));
im2_conv = (real(ifft2((freq_conv2))));


im0_conv = ifftshift(im0_conv);
im1_conv = ifftshift(im1_conv);
im2_conv = ifftshift(im2_conv);
% 
im0_conv = im0_conv(1:end-2*pad,1:end-2*pad);
im1_conv = im1_conv(1:end-2*pad,1:end-2*pad);
im2_conv = im2_conv(1:end-2*pad,1:end-2*pad);

subplot(3,4,3);imshow(im0_conv,[min(im0_conv(:)) max(im0_conv(:))]); title('Original. Gaussian LP 64');
subplot(3,4,7);imshow(im1_conv,[min(im1_conv(:)) max(im1_conv(:))]); title('Broadband. Gaussian LP 64');
subplot(3,4,11);imshow(im2_conv,[min(im2_conv(:)) max(im2_conv(:))]); title('High Pass. Gaussian LP 64');

mse0_g64cutoff = sum(sum(sum((double(im0_conv) - double(im0)).^2)))/numel(im0);
mse1_g64cutoff = sum(sum(sum((double(im1_conv) - double(im0)).^2)))/numel(im0);
mse2_g64cutoff = sum(sum(sum((double(im2_conv) - double(im0)).^2)))/numel(im0);

snr0_g64cutoff = 10*log(sig_orig/mse0_g64cutoff);
snr1_g64cutoff = 10*log(sig_orig/mse1_g64cutoff);
snr2_g64cutoff = 10*log(sig_orig/mse2_g64cutoff);

isnr1g64 = snr1_g64cutoff - snr1_orig;
isnr2g64 = snr2_g64cutoff - snr2_orig;

fprintf('************************* PART C START ****************************************\n');
fprintf('GaussianLP 64 Original Filtered and Original Image MSE1 = %f SNR = %f\n', mse0_g64cutoff, snr0_g64cutoff);
fprintf('GaussianLP 64 Broadband Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse1_g64cutoff, snr1_g64cutoff, isnr1g64);
fprintf('GaussianLP 64 High Pass Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse2_g64cutoff, snr2_g64cutoff, isnr2g64);
fprintf('************************* PART C END   ****************************************\n\n');


%% PART D

U_cutoff_H = 34;
SigmaH = 0.19 * 256 / U_cutoff_H;
[U,V] = meshgrid(-128:127,-128:127);
HtildeCenter = exp((-2*pi*SigmaH^2)/(256.^2)*(U.^2 + V.^2));
Htilde = fftshift(HtildeCenter);
H = ifft2(Htilde);
H2 = fftshift(H);
ZPH2 = zeros(512,512);
ZPH2(1:256,1:256) = H2;
freq_ZPH2 = fft2(ZPH2);
% freq_ZPH2 = fftshift(freq_ZPH2);


pad = 128;
im0pad512 = zeros(512,512);
im1pad512 = zeros(512,512);
im2pad512 = zeros(512,512);
im0pad512(pad+1:end-pad,pad+1:end-pad) = im0;
im1pad512(pad+1:end-pad,pad+1:end-pad) = im1;
im2pad512(pad+1:end-pad,pad+1:end-pad) = im2;
f_im0pad512 = fft2(im0pad512);
f_im1pad512 = fft2(im1pad512);
f_im2pad512 = fft2(im2pad512);
% 
% f_im0pad512 = fftshift(f_im0pad512);
% f_im0pad512 = fftshift(f_im0pad512);
% f_im0pad512 = fftshift(f_im0pad512);


freq_conv0=f_im0pad512 .* freq_ZPH2;
freq_conv1=f_im1pad512 .* freq_ZPH2;
freq_conv2=f_im2pad512 .* freq_ZPH2;

im0_conv = (real(ifft2((freq_conv0))));
im1_conv = (real(ifft2((freq_conv1))));
im2_conv = (real(ifft2((freq_conv2))));


im0_conv = ifftshift(im0_conv);
im1_conv = ifftshift(im1_conv);
im2_conv = ifftshift(im2_conv);
% 
im0_conv = im0_conv(1:end-2*pad,1:end-2*pad);
im1_conv = im1_conv(1:end-2*pad,1:end-2*pad);
im2_conv = im2_conv(1:end-2*pad,1:end-2*pad);


subplot(3,4,4);imshow(im0_conv,[min(im0_conv(:)) max(im0_conv(:))]);title('Original.Gaussian LP 34');
subplot(3,4,8);imshow(im1_conv,[min(im1_conv(:)) max(im1_conv(:))]);title('Broadband.Gaussian LP 34');
subplot(3,4,12);imshow(im2_conv,[min(im2_conv(:)) max(im2_conv(:))]);title('Highpass.Gaussian LP 34');


mse0_g34cutoff = sum(sum(sum((double(im0_conv) - double(im0)).^2)))/numel(im0);
mse1_g34cutoff = sum(sum(sum((double(im1_conv) - double(im0)).^2)))/numel(im0);
mse2_g34cutoff = sum(sum(sum((double(im2_conv) - double(im0)).^2)))/numel(im0);

snr0_g34cutoff = 10*log(sig_orig/mse0_g34cutoff);
snr1_g34cutoff = 10*log(sig_orig/mse1_g34cutoff);
snr2_g34cutoff = 10*log(sig_orig/mse2_g34cutoff);

isnr1g34 = snr1_g34cutoff - snr1_orig;
isnr2g34 = snr2_g34cutoff - snr2_orig;

fprintf('************************* PART D START ****************************************\n');
fprintf('GaussianLP 34 Original Filtered and Original Image MSE1 = %f SNR = %f\n', mse0_g34cutoff, snr0_g34cutoff);
fprintf('GaussianLP 34 Broadband Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse1_g34cutoff, snr1_g34cutoff, isnr1g34);
fprintf('GaussianLP 34 High Pass Gaussian Filtered and Original Image MSE = %f SNR =%f ISNR = %f\n', mse2_g34cutoff, snr2_g34cutoff, isnr2g34);
fprintf('************************* PART D END ****************************************\n\n');
