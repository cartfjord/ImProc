function interactiveLine(imgEdge,imgRadon,N);
%FUNCTION interactiveLine(imgEdge,imgRadon,N);
%   Parameters:
%     - imgEdge: Edge image
%     - imgRadon: Radon transform of imgEdge
%     - N: Number of lines to be drawn

% Display the radon transform
figure;
imshow(imgRadon,[]);
colormap(jet);

% Click some points
disp('Select as many points as required')
[X,Y] = ginput(N);

% Display crosses at selected points
hold on;
plot(X,Y,'mx');
hold off;

% Obtain some dimensions
[h w]= size(imgEdge);
[hr wr] = size(imgRadon);

% Display the edge image with overlaid lines
figure;
imshow(imgEdge,[]);
hold on;
for i=1:N,
    [LX LY] = tracedroite(w,h,wr,hr,X(i),Y(i));
    plot(LX,LY);
end
hold off;
