function [images, avcolours, histograms] = ReadAllTrainingFiles(path, newheight, newwidth)

    imagefiles = dir([path '*.jpg']);      
    nfiles = length(imagefiles);    % Number of files found

    images = cell(nfiles);
    avcolours = cell(nfiles);
    histograms = cell(nfiles);

    %for each file add to list
    for i=1:nfiles
       currentfilename = strcat(path,imagefiles(i).name);
       currentimage = imread(currentfilename);
       images{i} = imresize(currentimage, [newheight, newwidth]);
       %add its average colour to a list
       avcolours{i} = mean(reshape(images{i}, size(images{i},1) * size(images{i},2), size(images{i},3)));
       %histograms{i} = histcounts(images{i}, 40);
    end

end
