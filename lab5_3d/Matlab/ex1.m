close all;

imL = imread('../Stereo/Dist=2/pair1/x=-0_1.jpg');
imR = imread('../Stereo/Dist=2/pair1/x=0_1.jpg');

imL = imresize(imL, 0.4, 'nearest');
imR = imresize(imR, 0.4, 'nearest');

figure;
subplot(2,2,1);
imshow(imL);
title('Left image');

subplot(2,2,2);
imshow(imR);
title('Right image');


%% Create the disparity map and plot it
blockSize = 3;
imRes = Matching(imL, imR, 45, blockSize);

subplot(2,2,[3 4]);
imshow(imRes,[]);
title(['Disparity map, Blocksize=', num2str(blockSize)]);
%filenames: "disperitymap_blocksize=3.png", "disperitymap_blocksize=9.png"


%The blockSize determines the size of the window over which the disparity 
%(i.e the difference between the images) is calculated. A larger blockSize
%gives a more precise result, but the computation compleixty grows by 
%O(blockSize^2) and is therefore expensive.

%% (Optional)
imResFiltered = imfilter(imRes, fspecial('average', 2));
imshow(imResFiltered,[]);
title(['Disparity map filtered, Blocksize=', num2str(blockSize)]);
%filename: "disperitymap_blocksize=3_filtered.png"

%% (Optional)
imL_d2_x0pt1 = imread('../Stereo/Dist=2/pair1/x=-0_1.jpg');
imR_d2_x0pt1 = imread('../Stereo/Dist=2/pair1/x=0_1.jpg');

imL_d4_x0pt1 = imread('../Stereo/Dist=4/pair1/x=-0_1.jpg');
imR_d4_x0pt1 = imread('../Stereo/Dist=4/pair1/x=0_1.jpg');

imL_d4_x0pt4 = imread('../Stereo/Dist=4/pair2/x=-0_4.jpg');
imR_d4_x0pt4 = imread('../Stereo/Dist=4/pair2/x=0_4.jpg');

blockSize = 1;

dmax = [170 22 85];
for i = 1:3
    imRes = Matching(imL_d2_x0pt1, imR_d2_x0pt1, dmax, blockSize);
    subplot(3,3,i);
    imshow(imRes,[]);
    title(['Dist = 2, x = \pm0.1, d_{max} = ',num2str(dmax(i))]);
end

for i = 1:3
    imRes = Matching(imL_d4_x0pt1, imR_d4_x0pt1, dmax, blockSize);
    subplot(3,3,i+3);
    imshow(imRes,[]);
    title(['Dist = 4, x = \pm0.1, d_{max} = ',num2str(dmax(i))]);
end

for i = 1:3
    imRes = Matching(imL_d4_x0pt4, imR_d4_x0pt4, dmax, blockSize);
    subplot(3,3,i+6);
    imshow(imRes,[]);
    title(['Dist = 4, x = \pm0.4, d_{max} = ',num2str(dmax(i))]);
end

%filename: "disperitymaps_last_optional.png"

%From looking at the output X seems to be the distance between the two
%cameras/eyes and the Dist is the distance to the object from the viewer.