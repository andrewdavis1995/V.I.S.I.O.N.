function toreturn = ReadImage(a, rows, columns, gaussian)

% TODO: workout preallocating of arrays


img = imread(a);

[h, w, p] = size(img);

segmentWidth = int32(w / columns);
segmentHeight = int32(h / rows);

exactW = w / columns;
excessWidth = abs(double(segmentWidth) - exactW);
extraWidthAfter = round(1 / excessWidth);

exactH = h / columns;
excessHeight = abs(double(segmentHeight) - exactH);
extraHeightAfter = round(1 / excessHeight);



% read all training images in
[images, avcolours, histograms] = ReadAllTrainingFiles('C:\Users\asuth\Desktop\Vision\Vision Assignment Images\Assignments\Images\out_natural_1k\', segmentHeight, segmentWidth);

disp(strcat(int2str(length(images)), ' images found'));


% create list of arrays
l = [];

% image is accessible from id - modulus and division
for i = 0:rows-1
    
    innerImage = [];
    
    for j = 0:columns-1
              
        rowStart = (1 + (i * segmentHeight));
        rowEnd = (((i + 1) * segmentHeight));
        columnStart = (1 + (j * segmentWidth));
        columnEnd = (((j + 1) * segmentWidth));
              
        if mod(i,extraHeightAfter) == 0 && i > 0
            rowEnd = rowEnd - 1;
        end
        if mod(j,extraWidthAfter) == 0 && j > 0
            columnEnd = columnEnd - 1;
        end
        
        try
            image = img(rowStart:rowEnd, columnStart:columnEnd, :);
         
            % work out which image to use in place of the section
            newimage = CalcReplacementImage(images, image, avcolours, histograms);
                
            % (horizontally) add the image to the sub image (row image)
            innerImage = [innerImage newimage];

        catch 
            %disp(strcat(i, '-', j,'-',rowEnd,'-', rowStart));
            %image = img(rowStart:rowEnd - 2, columnStart:columnEnd - 2, :);
        end
    end
    
    % (vertically) add the row imageto the overall image
    l = [l; innerImage];
    
end

%imshow(l);

display('DONE');

if gaussian < 1
    toreturn = l;
end

if gaussian > 0
    toreturn = imgaussfilt(l,gaussian);
end

%imshow(toreturn);

end