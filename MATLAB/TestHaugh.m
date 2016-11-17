function TestHaugh(path)
   
    imagefiles = dir([path '*.jpg']);      
    nfiles = length(imagefiles);    % Number of files found

%     fileID = fopen('C:/users/asuth/Desktop/testfiles.txt','w');
%     fprintf(fileID,'');
    
    overTotal = 0;
    totalLines = 0;
    
    for i = 1:nfiles

        currentfilename = strcat(path,imagefiles(i).name);
        img = imread(currentfilename);
        
        img = rgb2gray(img);

        edges = edge(img, 'Canny');

        %lines = houghlines(edges);

        %imshow(edges);

        [H, T, R] = hough(edges);

        peaks = houghpeaks(H, 20);

        lines = houghlines(edges, T, R, peaks);

        %imshow(lines);

        totalLength = 0;

%         figure, imshow(edges), hold on
% 
         max_len = 0;
%         min_len = norm(lines(1).point1 - lines(1).point2);
% 
% 
         for k = 1:length(lines)
%            xy = [lines(k).point1; lines(k).point2];
%            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%            % Plot beginnings and ends of lines
%            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%            % Determine the endpoints of the longest line segment
            len = norm(lines(k).point1 - lines(k).point2);
% 
            totalLength = totalLength + len;
            if ( len > max_len)
               max_len = len;
            end
% 
%            if len < min_len
%               min_len = len;
%            end
% 
         end

        

        total = (num2str(totalLength));
        mean = num2str(totalLength / length(lines));
        max = (num2str(max_len));
        
        totalLines = totalLines + length(lines);
        
        outputStr = strcat(total, '---', mean, '---', max, '\n');
                
        
%         fileID = fopen('C:/users/asuth/Desktop/testfiles.txt','a');
%         fprintf(fileID,outputStr);
%         fclose(fileID);
%         
        overTotal = overTotal + totalLength;
        
    end
    
    overallMean = overTotal / totalLines;
    
    msgbox(num2str(overTotal));
    msgbox(num2str(overallMean));
    
    
end