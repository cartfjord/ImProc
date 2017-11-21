im = imread('../Images/ground.png');
im2 = imread('../Images/view1.png');

%%Convert the disperity map into a depth map
depthMap = 255 - DepthCompute(im,30,600);
subplot(2,2,1);
imshow(depthMap);
title('Original depthmap');

%%Plot the image in 3d with the previously created depthmap. Applying a
%%medianfilter to remove noise for a better result.
subplot(2,2,2);
warp(medfilt2(depthMap,[9 9]),im2);
rotate3d on
title('3d plot based on depthmap');

%Plot the histogram of the depthmap.
subplot(2,2,3);
imhist(depthMap);
title('Histogram of depthmap');
%Descretizing the depthmap into three depths and assigning each of them a
%color depending on distance.

subplot(2,2,4);

[rows, cols] = size(depthMap);
depthMapColor = uint8(zeros(rows,cols,3));

threshold_1 = 66;
threshold_2 = 117;

depthMapTemp = zeros(rows, cols);
depthMapTemp(depthMap <  threshold_1) = 255;
depthMapColor(:,:,3) = depthMapTemp;

depthMapTemp = zeros(rows, cols);
depthMapTemp(depthMap >= threshold_1 & depthMap < threshold_2) = 255;
depthMapColor(:,:,2) = depthMapTemp;

depthMapTemp = zeros(rows, cols);
depthMapTemp(depthMap >= threshold_2) = 255;
depthMapColor(:,:,1) = depthMapTemp;

imshow(depthMapColor);
title('Quantized depthmap');

%% d) The depths in each segment seems to be Gaussian distributed.
%%By choosing the number of quantizer steps we wanted it should be fairly
%%simple to write an algorithm that autocorrelates a Gaussian distribution
%%with the histogram and thus finds the mean of each depth. The best
%%solution would then by to put the thresholds exactly in the middle of the
%%Gaussian distributions. By doing this you minimize the Euclidean distance
%%between a sampled depth and its correct Gaussian distribution, maximizing
%%your probability of setting the thresholds correctly. 