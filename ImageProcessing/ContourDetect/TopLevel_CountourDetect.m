%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEL715 Image Processing : Assignment 2
% Piyush Kaul  : 2015EEZ7544
%
% Description: This File has test code for Contour Tracing
%              using Canny Edge Detection and Morphological Operations
%              GBVS library has been used for saliency detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TopLevel_ContourDetect()

% ADD PATHS
addpath('attachments')
addpath('gbvs');

% Read Image
img=imread('example1.jpg');

% Saliency Detection through GBVS
out_gbvs = gbvs(img);

% Thresholding of Saliency
saliency_img= (out_gbvs.master_map_resized);
threshold=numel(find(saliency_img > 0.1))/numel(saliency_img);
threshold=threshold-0.51;
saliency_img(find(saliency_img < threshold )) = 0;
figure;imshow(saliency_img);

% Saliency Corrrect Image
saliency_img3=repmat(saliency_img,1,1,3);
saliency_img4=uint8(saliency_img3);
saliency_corrected_img=saliency_img4.*img;
%saliency_corrected_img = pad_replicate(saliency_corrected_img);

% Find Canny Edge and Harris Corner.
%BW2 = edge(rgb2gray(saliency_corrected_img),'log',0.01);
BW2 = edge(rgb2gray(img),'canny',0.2, sqrt(2));
cor = corner(rgb2gray(img),'QualityLevel',0.01', 'SensitivityFactor' , 0.02);

% Dilation of saliency image
se = strel('disk', 10);
saliency_img = imdilate(saliency_img,se);

% Anding Saliency and Canny Output
BW4 = BW2 & saliency_img;
figure;
imshow(saliency_corrected_img);
figure;
imshow(img);
hold on;
h = imshow(BW4);
set(h, 'AlphaData', 0.5)
x = cor(:,1);
y = cor(:,2);
plot(cor(:,1),cor(:,2),'r+');
k = convhull(x,y);
%figure; plot(x(k),y(k),'r-');

%Find the Connectivity Map and remove unimportant edges.
CC = bwconncomp(BW4);
xy = hough_poly(BW4);
BW5 = BW4;


numPixels = cellfun(@numel,CC.PixelIdxList);
for obs=1:CC.NumObjects
    weightedPixels(obs) = sum(saliency_img(CC.PixelIdxList{obs}));
end 

% Sort as per weighted pixesl and number of Pixels
[valw,idw] = sort(weightedPixels, 'descend');
[vals,idx] = sort(numPixels, 'descend');

% Remove unimporant pixels
for reg=round(3*CC.NumObjects/4):CC.NumObjects
  %  BW5(CC.PixelIdxList{idw(reg)}) = 0;
end 

for reg=round(3*CC.NumObjects/4):CC.NumObjects
    BW5(CC.PixelIdxList{idx(reg)}) = 0;
end 
figure;imshow(BW5)

% Join Disconnected Edges
BWPOS = join_disconnected1(BW5, img, out_gbvs.master_map_resized);

% Find boundaries of final object
B = bwboundaries(BWPOS);

% Plot the contours.
figure(100);
imshow(img);
hold on;
numobs = min(numel(B),8);

for ix = 1:numobs
    plot(B{ix}(:,2),B{ix}(:,1), 'g', 'LineWidth',2);
    hold on;
end

end 

function BWPOS=join_disconnected1(BW5, img, saliency_img)
BWOUT = BW5;

% Find Distances to nearest nonzero point D<3 * D>1
[D,IDX] = bwdist(BW5);
smallindexes = find(D < 3 & D > 1);

% Find lines connecting to nearest nonzero point
for itr=smallindexes(:)'
    [x1,y1] = ind2sub(size(BW5), itr);
    [x2,y2] = ind2sub(size(BW5), IDX(itr));
    [xf,yf] = bresenham(x1,y1,x2,y2);
    BWOUT(xf,yf) = 1;
end 

figure;imshow(BWOUT);

% Find Negative of the image
BWNEG = ~BWOUT;
figure; imshow(BWNEG);

% Connectivity Analysis
cc = bwconncomp(BWNEG);

% List of Pixels at four corners overlapped with Saliency Map
zeropixels = find(saliency_img < 0.01);
[x,y] = size(BW5);
cornerpixels = [1 sub2ind([x y],x,1) sub2ind([x y], 1,y) sub2ind([x y], x,y)];
zeropixels = intersect(zeropixels,cornerpixels);

% For any regions connected to Four Corners overlapped with Saliency Map
% remove those regions.
for obs=1:cc.NumObjects
    %if find(cc.PixelIdxList{obs}==1)
    if ~isempty(intersect(cc.PixelIdxList{obs}, zeropixels))
        other_idx = setdiff([1:numel(BWNEG)], cc.PixelIdxList{obs}');
        BWNEG(other_idx) = 0;
    end 
end

% Find Positive and Erode
figure;imshow(BWNEG);
BWPOS=~BWNEG;
se = strel('disk',5);
BWPOS = imerode(BWPOS, se);
figure;imshow(BWPOS);
end 
