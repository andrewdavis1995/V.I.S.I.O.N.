function ret = IndividualKNN(userSettings, path)

    
    img = imread(path);
       %images{i} = imresize(currentimage, [newheight, newwidth]);
       %add its average colour to a list
       %avcolours{i} = mean(reshape(images{i}, size(images{i},1) * size(images{i},2), size(images{i},3)));
       %histograms{i} = histcounts(images{i}, 40);

    [h,w,p] = size(img);

    
    values = [];
    
    for y = 2:h - 1
        for x = 2:w-1
            
                
            current = img(y, x, :);
            
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
        
    ret = (mean(values));
    
end
    