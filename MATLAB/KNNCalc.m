function overallMean = KNNCalc(userSettings, path)

    imagefiles = dir([path '*.jpg']);      
    nfiles = length(imagefiles);    % Number of files found

    count = 0;
    totalMeans = 0;
    
    %for each file add to list
    for i=1:nfiles
       currentfilename = strcat(path,imagefiles(i).name);
       img = imread(currentfilename);
       %images{i} = imresize(currentimage, [newheight, newwidth]);
       %add its average colour to a list
       %avcolours{i} = mean(reshape(images{i}, size(images{i},1) * size(images{i},2), size(images{i},3)));
       %histograms{i} = histcounts(images{i}, 40);

    [h,w,p] = size(img);

    
    values = [];
    
    for y = 2:h - 1
        for x = 2:w-1
            
            try
                current = img(y, x, :);
            catch
                msgbox(strcat(num2str(y), '-', num2str(x)));
            end
            
            settingsDone = 0;
            diffTotal = 0;
            
            if userSettings(1, 2) == 1 % up
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(3, 2) == 1 % down
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(2, 1) == 1 % left
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(2, 3) == 1 % right
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(1, 1) == 1 % top left
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(1, 3) == 1 % top right
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(3, 1) == 1 % bottom left
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            if userSettings(3, 3) == 1 % bottom right
                up = img(y-1, x);
                diffTotal = diffTotal + sum(abs(current - up));
				settingsDone = settingsDone + 1;
            end
            
			diffTotal = diffTotal / settingsDone;
             
            values = [values; diffTotal];
            
        end
    end
        
    disp(mean(values));
    
    totalMeans = totalMeans + mean(values);
    count = count + 1;
    
    end
    
    

    overallMean = totalMeans / count;
    
end