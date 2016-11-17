function [toreturn, fileNames, fileDescs] = ReadImage(a, rows, columns, gaussian)

% TODO: workout preallocating of arrays
tic

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
[images, avcolours, topcols, bottcols, allFileNames] = ReadAllTrainingFiles('C:\Users\asuth\Desktop\Vision\Training\Natural\', segmentHeight, segmentWidth);

disp(strcat(int2str(length(images)), ' images found'));


% create list of arrays
l = [];

fileNames = repmat({''},rows,columns);
fileDescs = repmat({''},rows,columns);


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
            [newimage, filename, description] = CalcReplacementImage(images, image, avcolours, topcols, bottcols, segmentHeight, segmentWidth, allFileNames);
                
            % (horizontally) add the image to the sub image (row image)
            innerImage = [innerImage newimage];
            
            fileNames{i + 1, j + 1} = char(filename);
            fileDescs{i + 1, j + 1} = char(description);

         catch 
            %disp('Error');
            %image = img(rowStart:rowEnd - 2, columnStart:columnEnd - 2, :);
         end
    end
    
    % (vertically) add the row imageto the overall image
    l = [l; innerImage];
    
end

%imshow(l);

disp(fileNames{2,1});

display('DONE');

if gaussian < 1
    toreturn = l;
end

if gaussian > 0
    toreturn = imgaussfilt(l,gaussian);
end


% % if noise > 0
% 	%toreturn = medfilt2(toreturn);
% 	toreturn = wiener2(toreturn, [5, 5]);
% % end

%imshow(toreturn);
toc

end