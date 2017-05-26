%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEL715 Image Processing : Assignment 1
% Piyush Kaul : 2015EEZ7544
%
% Description: This File implements Harris Corner Detector.
%              Reference : http://www.bmva.org/bmvc/1988/avc-88-023.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [coord] = HarrisCornerDetector(imageIn)
[height, width] = size(imageIn);

%sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];% Gonzalez Woods, Figure 3.41)(d)[-1  -1 -1; 0 0 0; 1 1 1]
%sobel_x = [-1 0 1; -2 0 2; -1 0 1];% Gonzalez Woods, Figure 3.41 (d)[-1 0 1; -1 0 1; -1 0 1]
sobel_y = [-1 0 0; 1 0 0; 0 0 0];
sobel_x = [-1 1 0; 0 0 0; 0 0 0];

grad_y = conv2(double(imageIn),sobel_y,'same');
grad_x = conv2(double(imageIn),sobel_x,'same');

IXX = grad_x .* grad_x;
IYY = grad_y .* grad_y;
IXY = grad_x .* grad_y;
sigma = 2;
gkernel = fspecial('gaussian',fix(6*sigma), sigma);

SXX = conv2(IXX, gkernel,'same');
SXY = conv2(IXY, gkernel,'same');
SYY = conv2(IYY, gkernel,'same');

[xsz,ysz] = size(SXX);
k = 0.05;
for xidx = 1:xsz
    for yidx = 1:ysz
        M = [SXX(xidx,yidx) SXY(xidx,yidx) ; SXY(xidx,yidx) SYY(xidx,yidx)];
        resp(xidx,yidx) = det(M) - k*(trace(M))^2;
    end 
end 
resp = abs(resp);
maxr = max(max(resp));
minr = min(min(resp));
resp2 = (resp - minr)./(maxr-minr) * 100;
%maximum filter
masksize = 6;
resp2max = ordfilt2(resp2,masksize^2,ones(masksize ,masksize ));
resp3 = (resp2max == resp2) & (resp2max > 10);
resp4 = resp3 * 128;
[ix,iy] = find(resp3);
figure;surf(resp2);
figure;imshow(imageIn);
hold on;
plot(ix,iy,'bo');
coord = [ix iy];

