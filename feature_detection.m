function [ y, x ] = feature_detection( image_in, threshold )
%FEATURE_DETECTION Summary of this function goes here
%   Detailed explanation goes here

gray_image = double(rgb2gray(image_in));

sobelx = fspecial('sobel');
sobely = sobelx';
i_x = filter2(sobelx, gray_image);
i_y = filter2(sobely, gray_image);

i_x_squared = i_x.* i_x;
i_xy = i_x.* i_y;
i_y_squared = i_y.* i_y;

G = fspecial('gaussian', [3 3], 1.5);

f_x_squared = filter2(G, i_x_squared);
f_xy = filter2(G, i_xy);
f_y_squared = filter2(G, i_y_squared);

%calculate CS:
epsilon = 1 * 10^-16; % a small value, prevent divide by zero
numerator = (f_x_squared.* f_y_squared) - (f_xy.^2);
denominator = f_x_squared + f_y_squared + epsilon;

CS = numerator ./ denominator;

%The radius can be values like 1 (for a 3x3 window) or 2 (for a 5x5 window)
nonmax_radius = 2;
corner_thresh = threshold;
[y, x] = nonmaxsuppts(CS, nonmax_radius, corner_thresh);

%{
length(x)

figure, imshow(image_in), hold on
numvals = length(x);
for i = 1:1:numvals
   
   plot(x(i), y(i), 'r.'); 
    
end
%}

end