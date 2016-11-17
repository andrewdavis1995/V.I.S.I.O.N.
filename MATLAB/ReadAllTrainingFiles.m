function [images, avcolours, topcols, bottcols, filenames] = ReadAllTrainingFiles(path, newheight, newwidth)

    tic

    imagefiles = dir([path '*.jpg']);      
    nfiles = length(imagefiles);    % Number of files found

    images = cell(nfiles);
    avcolours = cell(nfiles);
    %histograms = cell(nfiles);
    topcols = cell(nfiles);
    bottcols = cell(nfiles);
    filenames = [];

    %for each file add to list
    for i=1:nfiles
       filenames = [filenames; strcat(path,imagefiles(i).name)];
       currentimage = imread(strcat(path,imagefiles(i).name));
       images{i} = imresize(currentimage, [newheight, newwidth]);
       
       imgTop = imcrop(images{i}, [0 0 newwidth (newheight/2)]);
       imgTop = imresize(imgTop, [newheight, newwidth]);
       topcols{i} = mean(reshape(imgTop, size(imgTop,1) * size(imgTop,2), size(imgTop,3)));
%               
       imgBott = imcrop(images{i}, [0 (newheight/2) newwidth newheight]);
       imgBott = imresize(imgBott, [newheight, newwidth]);
       bottcols{i} = mean(reshape(imgBott, size(imgTop,1) * size(imgTop,2), size(imgTop,3)));
       
       %add its average colour to a list
       avcolours{i} = mean(reshape(images{i}, size(images{i},1) * size(images{i},2), size(images{i},3)));
       %histograms{i} = histcounts(images{i}, 40);
    end

    toc
    
end
