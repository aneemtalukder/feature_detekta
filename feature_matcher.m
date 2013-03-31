function [ ] = feature_matcher( image1, image2, x1, y1, features1, x2, y2, features2 )
%FEATURE_MATCHER matches features in two different images

Sbs = [image1 image2];

numfeatures1 = size(features1,3);
numfeatures2 = size(features2,3);


matchtable = [];

for i = 1:1:numfeatures1
    
    if any(features1(:,:,i)) == 0
        continue;
    end
    
    bestmatchindex = -100;
    lowestdistance = inf;
    secondbest = 1;
    
    for j = 1:1:numfeatures2
        
        if any(features2(:,:,j)) == 0
            continue;
        end
        
        %match shift using Euclidean distance:
        euc_dist = norm(features1(:,:,i) - features2(:,:,j));
        
        if euc_dist < lowestdistance
            
            secondbest = lowestdistance;
            
            lowestdistance = euc_dist;
            bestmatchindex = j;
            
        end
        
    end
    
    if bestmatchindex ~= -100
        ratio = lowestdistance / secondbest;
        
        if ratio < 0.7
            match = [i bestmatchindex];
            matchtable = vertcat(matchtable, match);
        end
    end
    
end

f = figure;

set(f, 'name', 'SIFT');

imshow(Sbs), hold on

[nummatches discard] = size(matchtable);

addwidth = size(image1, 2);


% numvals = length(x1);
% for i = 1:1:numvals
%     
%     plot(x1(i), y1(i), 'r.');
%     
% end
% 
% numvals = length(x2);
% for i = 1:1:numvals
%     
%     plot(x2(i) + addwidth, y2(i), 'r.');
%     
% end

for i = 1:10:nummatches
    
    %feature 1
    x(1) = x1(matchtable(i,1));
    y(1) = y1(matchtable(i,1));
    
    plot(x(1), y(1), 'g.');
    
    %feature 2
    x(2) = x2(matchtable(i,2)) + addwidth;
    y(2) = y2(matchtable(i,2));
    
    plot(x(2), y(2), 'g.');
    
    line(x, y, 'Color', [1 0 0]);
    
end

