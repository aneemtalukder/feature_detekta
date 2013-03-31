function [ ] = feature_analysis( image1name, image2name, feature_thresh)

%example usage:
%feature_analysis('bikes1.png', 'bikes2.png', 5000);

image1 = imread(image1name);
[y1 x1] = feature_detection(image1, feature_thresh);
features1 = simple_sift_descriptor(x1,y1,image1);
window1 = window_descriptor(y1,x1,image1);

%image2holder = zeros(size(image1));


image2 = imread(image2name);

% [height width color] = size(image2);
% 
% for i = 1:1:height
%     for j = 1:1:width
%         for k = 1:1:color
%         image2holder(i,j,k) = image2(i,j,k);
%         end
%     end
% end
% 
% image2 = im2double(image2holder);

[y2 x2] = feature_detection(image2, feature_thresh);
features2 = simple_sift_descriptor(x2,y2,image2);
window2 = window_descriptor(y2,x2,image2);

window_matching(image1, image2, x1, y1, window1, x2, y2, window2);
feature_matcher( image1, image2, x1, y1, features1, x2, y2, features2 );

end