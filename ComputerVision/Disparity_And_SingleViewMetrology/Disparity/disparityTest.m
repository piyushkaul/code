imset = 'set1';
im0=imread([imset '/im0.png']);
im1=imread([imset '/im1.png']);
im0gray = rgb2gray(im0);
im1gray = rgb2gray(im1);
% figure;
% subplot(3,1,1);
% imshow(im0gray);
% subplot(3,1,2);
% imshow(im1gray);

%%
% Display both images side by side. Then, display a color composite
% demonstrating the pixel-wise differences between the images.

figure;
imshowpair(im0, im1,'montage');
title('im0 (left); im1 (right)');
figure;
imshow(stereoAnaglyph(im0,im1));
title('Composite Image (Red - Left Image, Cyan - Right Image)');


%%
% There is an obvious offset between the images in orientation and
% position. The goal of rectification is to transform the images, aligning
% them such that corresponding points will appear on the same rows in both
% images.

%% Step 2: Collect Interest Points from Each Image
% The rectification process requires a set of point correspondences between
% the two images. To generate these correspondences, you will collect
% points of interest from both images, and then choose potential matches
% between them. Use |detectSURFFeatures| to find blob-like features in both
% images.
blobs1 = detectSURFFeatures(im0gray, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(im1gray, 'MetricThreshold', 2000);

%%
% Visualize the location and scale of the thirty strongest SURF features in
% im0 and im1.  Notice that not all of the detected features can be matched
% because they were either not detected in both images or because some of
% them were not present in one of the images due to camera motion.
figure; 
imshow(im0);
hold on;
plot(selectStrongest(blobs1, 30));
title('Thirty strongest SURF features in im0');

figure; 
imshow(im1); 
hold on;
plot(selectStrongest(blobs2, 30));
title('Thirty strongest SURF features in im1');

%% Step 3: Find Putative Point Correspondences
% Use the |extractFeatures| and |matchFeatures| functions to find putative
% point correspondences. For each blob, compute the SURF feature vectors
% (descriptors).
[features1, validBlobs1] = extractFeatures(im0gray, blobs1);
[features2, validBlobs2] = extractFeatures(im1gray, blobs2);

%%
% Use the sum of absolute differences (SAD) metric to determine indices of
% matching features.
indexPairs = matchFeatures(features1, features2, 'Metric', 'SAD', ...
  'MatchThreshold', 5);

%%
% Retrieve locations of matched points for each image.
matchedPoints1 = validBlobs1(indexPairs(:,1),:);
matchedPoints2 = validBlobs2(indexPairs(:,2),:);

%%
% Show matching points on top of the composite image, which combines stereo
% images. Notice that most of the matches are correct, but there are still
% some outliers.
figure; 
showMatchedFeatures(im0, im1, matchedPoints1, matchedPoints2);
legend('Putatively matched points in im0', 'Putatively matched points in im1');

%% Step 4: Remove Outliers Using Epipolar Constraint
% The correctly matched points must satisfy epipolar constraints. This
% means that a point must lie on the epipolar line determined by its
% corresponding point. You will use the |estimateFundamentalMatrix|
% function to compute the fundamental matrix and find the inliers that meet
% the epipolar constraint.
[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
  matchedPoints1, matchedPoints2, 'Method', 'RANSAC', ...
  'NumTrials', 10000, 'DistanceThreshold', 0.1, 'Confidence', 99.99);
  
if status ~= 0 || isEpipoleInImage(fMatrix, size(im0)) ...
  || isEpipoleInImage(fMatrix', size(im1))
  error(['Either not enough matching points were found or '...
         'the epipoles are inside the images. You may need to '...
         'inspect and improve the quality of detected features ',...
         'and/or improve the quality of your images.']);
end

inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);

figure;
showMatchedFeatures(im0, im1, inlierPoints1, inlierPoints2);
legend('Inlier points in im0', 'Inlier points in im1');

%% Step 5: Rectify Images
% Use the |estimateUncalibratedRectification| function to compute the
% rectification transformations. These can be used to transform the images,
% such that the corresponding points will appear on the same rows.
[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
  inlierPoints1.Location, inlierPoints2.Location, size(im1));
tform1 = projective2d(t1);
tform2 = projective2d(t2);

%%
% Rectify the stereo images, and display them as a stereo anaglyph.
% You can use red-cyan stereo glasses to see the 3D effect.
[im0Rect, im1Rect] = rectifyStereoImages(im0, im1, tform1, tform2);
figure;
imshow(stereoAnaglyph(im0Rect, im1Rect));
title('Rectified Stereo Images (Red - Left Image, Cyan - Right Image)');

%% Step 6: Generalize The Rectification Process
% The parameters used in the above steps have been set to fit the two
% particular stereo images.  To process other images, you can use the
% |cvexRectifyStereoImages| function, which contains additional logic to
% automatically adjust the rectification parameters. The image below shows
% the result of processing a pair of images using this function.
%cvexRectifyImages('parkinglot_left.png', 'parkinglot_right.png');

%% References
% [1] Trucco, E; Verri, A. "Introductory Techniques for 3-D Computer Vision."
% Prentice Hall, 1998.
% 
% [2] Hartley, R; Zisserman, A. "Multiple View Geometry in Computer Vision."
% Cambridge University Press, 2003.
% 
% [3] Hartley, R. "In Defense of the Eight-Point Algorithm." IEEE(R)
% Transactions on Pattern Analysis and Machine Intelligence, v.19 n.6, June
% 1997.
%
% [4] Fischler, MA; Bolles, RC. "Random Sample Consensus: A Paradigm for
% Model Fitting with Applications to Image Analysis and Automated
% Cartography." Comm. Of the ACM 24, June 1981.

%displayEndOfDemoMessage(mfilename)




% [frameLeftRect, frameRightRect] = ...
%     rectifyStereoImages(im0, im1, stereoParams);
% 
% figure;
% imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
% title('Rectified Video Frames');
% rectifyStereoImages(

im0RectGray = rgb2gray(im0Rect);
im1RectGray = rgb2gray(im1Rect);
disparityMap = disparity(im0RectGray, im1RectGray);
figure;
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet
colorbar