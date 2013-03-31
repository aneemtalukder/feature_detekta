function [ point_windows ] = window_descriptor(y,  x, image_in)
%what to do about points that are near edges of the image?


%make a 3D array of 11 X 11 matrices:
grayimage = rgb2gray(image_in);

numvals = length(x);
[height width] = size(grayimage);

point_windows = zeros(11, 11, numvals);

for i = 1:1:numvals
    
    %ignore the ones near the borders:
    if x(i) <= 5 || y(i) <= 5 || x(i) + 5 >= width || y(i) + 5 >= height
        %simply do nothing
    else
        startx = x(i) - 5;
        endx = x(i) + 5;
        starty = y(i) - 5;
        endy = y(i) + 5;
        submatrix = double(grayimage(starty:endy, startx:endx));
        point_windows(:,:,i) = double(submatrix);
        %myArray = cat(3,myArray,zeros(500,800));
    end
end

point_windows = double(point_windows);

end

