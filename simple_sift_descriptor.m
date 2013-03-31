function [ all_descriptors ] = simple_sift_descriptor( x, y, image_in )
%SIMPLE_SIFT_DESCRIPTOR

sobelx = fspecial('sobel');
sobely = sobelx';

grayimage = rgb2gray(image_in);


[height width] = size(grayimage);
i_x = filter2(sobelx, grayimage);
i_y = filter2(sobely, grayimage);
gradient_mag = sqrt(i_x.^2 + i_y.^2);

thetas = (180 / pi) * atan2(i_y, i_x);

numvals = length(x);

% 
% figure;
% hold on;
% imagesc(image_in)
% 
% numvals = length(x);
% for i = 1:1:numvals
%    
%    plot(x(i), y(i), 'r.');
%     
% end
% 
% pause

%use horzcat to combine the 8 bin vectors
all_descriptors = zeros(1, 128, numvals);
for i = 1:1:numvals
    %check if the patch goes past the boundaries and handle this case:
    if x(i) <= 20 || y(i) <= 20 || x(i) + 20 > width || y(i) + 20 > height
        %do nothing, feature is too close to the edge
        
    else
        feature_descriptor = [];
        
        degreeBins = zeros([1 45]);
        
        %go through the 41 x 41 patch and get the dominant orientation:
        for patchx = (x(i) - 20):1:(x(i) + 20)
            for patchy = (y(i) - 20):1:(y(i) + 20)
                
                theta = thetas(patchy, patchx);
                
                while theta < 0
                    theta = theta + 360;
                end
                
                %now increment the correct bin by adding the
                %gradient magnitude to it
                binNumber = ceil(theta / 8);
                if binNumber == 0
                    binNumber = 45;
                    %continue;
                end
                
                degreeBins(binNumber) = degreeBins(binNumber) + gradient_mag(patchy, patchx);
                
            end
        end
        
        %get most popular bin:
        [mostHits, indexmostHits] = max(degreeBins);
        
        mostHits = -inf;
        indexmostHits = 1;
        for hitdex = 1:45
            if degreeBins(hitdex) > mostHits
                mostHits = degreeBins(hitdex);
                indexmostHits = hitdex;
            end
        end
        
        %get dominant orientation:
        dominantOrientation = 8 * indexmostHits - 4;
        
        %divide it up into 16 parts:
        
        for widthdiv = 0:10:30
            for heightdiv = 0:10:30
                
                startWidthPix = x(i) - 20 + widthdiv;
                endWidthPix = startWidthPix + 10;
                startHeightPix = y(i) - 20 + heightdiv;
                endHeightPix = startHeightPix + 10;
                
                %{
                startWidthPix
                endWidthPix
                startHeightPix
                endHeightPix
                x(i)
                y(i)
                %}
                                
                %now iterate through every pixel through this 10x10 piece:
                histogram = zeros([1 8]);
                
                %make sure its 10 x 10
                
                
                for winc = startWidthPix:1:endWidthPix
                    for hinc = startHeightPix:1:endHeightPix
                        
                        theta = thetas(hinc,winc);
                        
                        theta = theta - dominantOrientation;
                        
                        while theta < 0
                            theta = theta + 360;
                        end
                        
                        %now increment the correct bin by adding the
                        %gradient magnitude to it
                        binNumber = ceil(theta / 45);
                        if binNumber == 0
                            binNumber = 8;
                        end
                        
                        histogram(binNumber) = histogram(binNumber) + gradient_mag(hinc, winc);
                        
                    end
                end
                
                feature_descriptor = horzcat(feature_descriptor, histogram);
                
            end
        end
        
        %normalize it
        feature_descriptor = feature_descriptor ./ norm(feature_descriptor);
        
        %threshold to 0.2
        for normindex = 1:1:128
            if feature_descriptor(normindex) > 0.2
                feature_descriptor(normindex) = 0.2;
            end
        end
        
        %re-normalize it
        feature_descriptor = feature_descriptor ./ norm(feature_descriptor);
        
        all_descriptors(:,:,i) = feature_descriptor;
        
    end
    
end

end