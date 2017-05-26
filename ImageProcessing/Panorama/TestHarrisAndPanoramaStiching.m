%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEL715 Image Processing : Assignment 1
% Piyush Kaul : 2015EEZ7544
%
% Description: This File has test code for Harris corner Detector 
%              and the implementation for Panorma Stiching using SIFT.
%              VL_FEAT Sift library has been used along with Matlab 
%              image processing toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%% Add VL FEAT to path
run('D:\\vlfeat-0.9.20\\toolbox\\vl_setup.m');

%% Test Harris Corner Detector using Checkerboard pattern
I = checkerboard(50,2,2);
[coordinates] = HarrisCornerDetector(I);


%% Read the image data
picset = 3;

%% Read image data
loc{1} = ['BhartiSchoolPics' num2str(picset) filesep '1s.png'];
loc{2} = ['BhartiSchoolPics' num2str(picset) filesep '2s.png'];
loc{3} = ['BhartiSchoolPics' num2str(picset) filesep '3s.png'];
%loc{4} = ['BhartiSchoolPics' num2str(picset) filesep '4s.png'];
%loc{5} = ['BhartiSchoolPics' num2str(picset) filesep '5s.png']
im{1} = imread(loc{1});
im{2} = imread(loc{2});
im{3} = imread(loc{3});
%im{4} = imread(loc{4});
%im{5} = imread(loc{5});

%% Plot the input images
figure;montage(loc);
numPics=3;

%% Initialize transforms to Identity matrix.
tform_overall(numPics) = projective2d(eye(3))

%% For All picture pairs. Do thye following
for picIdx=1:numPics-1
    
    % RGB to Grayscale
    gra1=rgb2gray(im{picIdx});
    gra2=rgb2gray(im{picIdx+1});

    % figure; imshow(gra);
    % Adaptive Histogram
    [graeq1] = adapthisteq(gra1);
    [graeq2] = adapthisteq(gra2);
    
    graeq1 = single(rgb2gray(im{picIdx}));
    graeq2 = single(rgb2gray(im{picIdx+1}));

    %figure; imshow(graeq1);
    [f1,d1] = vl_sift(single(graeq1)) ;
    %hold on;
    coordinates1 = f1(1:2,:);
    %plot(coordinates1(1,:),coordinates1(2,:) ,'bo');

    %figure; imshow(graeq2);
    % OBtain the SIFT Features
    [f2,d2] = vl_sift(single(graeq2)) ;
    %hold on;
    coordinates2 = f2(1:2,:);
    %plot(coordinates2(1,:),coordinates2(2,:) ,'bo');

    % Match the SIFT Features
    [matches, scores] = vl_ubcmatch(d1, d2 );
    
    match_coordinates1 = coordinates1(:,matches(1,:));
    match_coordinates2 = coordinates2(:,matches(2,:));

    %Estimate Geometric Transoform
    [tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(match_coordinates2',match_coordinates1','projective');
    figure; showMatchedFeatures(graeq1,graeq2,inlierPtsOriginal,inlierPtsDistorted);
    title('Matched inlier points');

    % Show the warped Images
    outputView = imref2d(size(graeq1));
    Ir = imwarp(graeq2,tform,'OutputView',outputView);
    %figure; imshow(Ir);
    %title('Recovered image');
    
    % Overall Transoform
    tform_overall(picIdx+1).T = tform_overall(picIdx).T * tform.T;
    %tgraeq2 = imwarp(graeq2,tform);
    %figure;imshow(tgraeq2);
end 


% Find the Output limits in world dimensions.
for ix=1:numPics
    [szy, szx, depth] = size(im{ix});
    [x(ix,:),y(ix,:)] = outputLimits(tform_overall(ix), [1 szx], [1 szy]);
end
max_x = fix(max(x(:,2)));
min_x = fix(min(x(:,1)));
max_y = fix(max(y(:,2)));
min_y = fix(min(y(:,1)));

% Find the central Image and take inverse transoform
midpoints = fix(x(:,2) + x(:,1))/2;
[val,idx] = sort(midpoints);
cent=idx(round((numPics+1)/2));
tform_cent = invert(tform_overall(cent));

% Find Transforms of all image relative to central Image
for ix=1:numPics
	tform_overall(ix).T = tform_cent.T * tform_overall(ix).T ;
end

% Find the output Limites again.
for ix=1:numPics
    [szy, szx, depth] = size(im{ix});
    [x(ix,:),y(ix,:)] = outputLimits(tform_overall(ix), [1 szx], [1 szy]);
end
max_x = fix(max(x(:,2)));
min_x = fix(min(x(:,1)));
max_y = fix(max(y(:,2)));
min_y = fix(min(y(:,1)));


% Now estimate size of final panorama image 
xsize = max_x - min_x;
ysize = max_y - min_y;

% Initialize final panorama image
final_stiched = zeros([ysize xsize 3],'uint8');

% Initialize blender
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');
panoramaView = imref2d([ysize xsize], [min_x max_x], [min_y max_y]);

for ix=1:numPics
    % Transform I into the panorama.
    warpedImage = imwarp(im{ix}, tform_overall(ix), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    final_stiched = step(blender, final_stiched, warpedImage, warpedImage(:,:,1));
end 
figure;
imshow(final_stiched);
axis;
title('Stiched Panorama');









