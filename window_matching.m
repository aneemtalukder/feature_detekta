function [ ] = window_matching( image1, image2, x1, y1, windows1, x2, y2, windows2 )

Sbs = [image1 image2];

numwindows = size(windows1, 3);
numwindows2 = size(windows2, 3);
matchtable = [];


for i = 1:1:numwindows
    
    if any(windows1(:,:,i)) == 0
        continue;
    end
    
    bestmatchindex = -100;
    maxdist = -inf;
    
    for j = 1:1:numwindows2
        
        if any(windows2(:,:,j)) == 0
            continue;
        end
        w1norm = windows1(:,:,i);
        w1norm = w1norm ./ norm(w1norm);
        w2norm = windows2(:,:,j);
        w2norm = w2norm ./ norm(w2norm);
        ncc = w1norm .* w2norm;
        ncc = sum(sum(ncc));
        
        if ncc > maxdist
            maxdist = ncc;
            bestmatchindex = j;
        end
        
    end
    
    if bestmatchindex ~= -100
        match = [i bestmatchindex];
        matchtable = vertcat(matchtable, match);
    end
    
end

marriage = [];
for i = 1:1:numwindows2
    
    if any(windows2(:,:,i)) == 0
        continue;
    end
    
    bestmatchindex = -100;
    maxdist = -inf;
    
    for j = 1:1:numwindows
        if any(windows1(:,:,j)) == 0
            continue;
        end
        w1norm = windows1(:,:,j);
        w1norm = w1norm ./ norm(w1norm);
        w2norm = windows2(:,:,i);
        w2norm = w2norm ./ norm(w2norm);
        ncc = w1norm .* w2norm;
        ncc = sum(sum(ncc));
        
        if ncc > maxdist
            maxdist = ncc;
            bestmatchindex = j;
        end
    end
    
    if bestmatchindex ~= -100
        %find i in the second column of matchtable
        matchdex = 0;
        for index = 1:1:length(matchtable)
            if matchtable(index, 2) == i
                matchdex = index;
            end
        end
        
        if matchdex ~= 0
            match = [bestmatchindex i];
            marriage = vertcat(marriage, match);
        end
        
    end
    
end

f = figure;

set(f, 'name', 'NCC');

imshow(Sbs), hold on
[nummatches discard] = size(marriage);
addwidth = size(image1, 2);

for i = 1:10:nummatches
    
    %feature 1
    x(1) = x1(marriage(i,1));
    y(1) = y1(marriage(i,1));
    
    plot(x(1), y(1), 'g.');
    
    %feature 2
    x(2) = x2(marriage(i,2)) + addwidth;
    y(2) = y2(marriage(i,2));
    
    plot(x(2), y(2), 'g.');
    
    line(x, y, 'Color', [1 0 0]);
    
end


end

