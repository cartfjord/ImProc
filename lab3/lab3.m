close all;
img = imread('ic2.tif');

[r,c] = size(img);
%add noise
img_n = imnoise(img,'gaussian',0,0.65);
imshow(img_n);
title('Noisy image, gaussian zero-mean noise, variance 0.65');


%% The differet filters:
figure;

filter_avg = ones(8,8) / 64;
img_filtered = imfilter(img_n,filter_avg);
subplot(1,3,1);
imshow(img_filtered);
title('Averaging filter');

img_filtered = medfilt2(img_n,[8 8]);
subplot(1,3,2);
imshow(img_filtered);
title('Median filter');

[img_filtered noise] = wiener2(img_n,[8 8]);
subplot(1,3,3);
imshow(img_filtered);
title('Wiener filter');
%I choose to use the Wiener filter. It is a close call in performance
%between the Wiener and Median filter. The averaging filter is not very
%good. The Wiener filter seems to be the best trade-off between denoising
%and keeping the edges clean for the next stage. If this was a real
%implementation task and not just a matlab simulation parameters such as
%computation / hardware complexity and power consumption should be taken
%into consideration as well.




figure;
%% The different image edge detection algorithms
%In the end I chose using a modified canny edge detector due to its vastly
%improved performance over the other alternatives. Again, in a real
%scenario a more light-weight algorithm may be preferable. I suspect that
%Matlabs canny edge function already binarizes the image. 

img_edge_canny = edge(img_filtered,'Canny',0.5);
% The following lines greatly improves the performance of the canny edge
% detector by preventing the edges of the image to be detected as edges. 
img_edge_canny(1:5,:) = 0;
img_edge_canny(end-5:end,:) = 0;
img_edge_canny(:,1:5) = 0;
img_edge_canny(:,end-5:end) = 0;

subplot(1,3,1);
imshow(img_edge_canny);
title('Modified Canny edge detector');


threshold = 70;
prewit_mask = [1 0 -1; 1 0 -1; 1 0 -1];
img_edge_grad_x = (filter2(prewit_mask,img_filtered));
img_edge_grad_y = (filter2(prewit_mask',img_filtered));
%% calculate the norm of the gradient and threshold
img_edge_grad_norm = zeros(r,c);
for i = 1:r
    for j = 1:c
        img_edge_grad_norm(i,j) = sqrt(...
            img_edge_grad_x(i,j)*img_edge_grad_x(i,j) + ...
            img_edge_grad_y(i,j)*img_edge_grad_y(i,j));
    end
end

img_edge_grad_norm(img_edge_grad_norm < threshold) = 0;

subplot(1,3,2);
imshow(img_edge_grad_norm);
title('Gradiant edge detector');

%% calculate the laplacian and threshold
threshold = 55;

laplacian_mask = [0 1 0; 1 -4 1; 0 1 0];
img_edge_laplacian = filter2(laplacian_mask,img_filtered);
img_edge_laplacian(abs(img_edge_laplacian) > threshold) = 255;

subplot(1,3,3);
imshow(uint8(img_edge_laplacian));
title('Laplacian edge detector');

%%Task 4: Compute the Radon transform
figure;
theta = 0:179;
[R,xp] = radon(img_edge_canny,theta);
imshow(R,[],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
colormap(gca,hot), colorbar;
title('Visualization of the Radon transform');

figure;
V = max(R);
V = V(1:90)+V(91:180); % Summing the vertical and horizontal lines for a
                       % better estimate of the true rotation angle.
[~,I] = max(V);
rot_angle = 90 - (I - 1);
imshow(imrotate(img,rot_angle,'bilinear','crop'));
title(['Image rotated ', num2str(rot_angle), ' degrees']);
%interactiveLine(img_edge_canny,R,20);
