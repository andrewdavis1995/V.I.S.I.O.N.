function [image, filename, description] = CalcReplacementImage (images, orig, avcolours, topCols, bottCols, newheight, newwidth, filenames)

    % gets a 3-dimension matrix of average R, G and B values for the
    % current segment
    avcolour = (mean(reshape(orig, size(orig,1) * size(orig,2), size(orig,3))));
         
%     if avcolor(2) > avcolor(1) + 30 && avcolor(2) > avcolor(3) + 20
%         %disp('GREEN');
%     end
    
    imlistsize = length(images);
        
%     orighist = histcounts(orig, 40);
%     origmode = median(median(orighist), 2);
    
    % start by setting the 'best' difference (most similar) in colour to be
    % the first item
    bestdiff = abs(avcolour - avcolours{1});
       
%     [h, w, d] = size(orig);
    
           
%     imghist = histograms{1};
    
%     besthist = pdist2(imghist', orighist', 'euclidean');
%     bestmode = median(median(besthist),2);
    
    bestpos = 1;
    partToUse = 0;
    
    %loop through all items, if better colour match than current best, 
    %then set best = current
    for i = 2:imlistsize
       
        %images{i} = imresize(images{i}, [h, w]);
        
        newav = avcolours{i};
        newtopav = topCols{i};
        newbottav = bottCols{i};
    
        coldiff = abs(avcolour - newav);
        coldiffTop = abs(avcolour - newtopav);
        coldiffBott = abs(avcolour - newbottav);
                
        if(coldiff < bestdiff)            
             bestdiff = coldiff;
             bestpos = i;
             partToUse = 0;
        end
             
        if(coldiffTop < bestdiff)            
             bestdiff = coldiffTop;
             bestpos = i;
             partToUse = 1;
        end
          
        if(coldiffBott < bestdiff)            
             bestdiff = coldiffBott;
             bestpos = i;
             partToUse = 2;
        end
%         imghist = histograms{i};
%         histodiff = pdist2(imghist', orighist', 'euclidean');
%                         
%         %disp(histodiff);
%         
%         themode = median(median(histodiff),2);
%         
%         
%         if (abs(themode - origmode) < abs(bestmode - origmode))
%             bestmode = themode;
%             bestpos = i;
%         end
        
    
    end
    
    
    %disp(filenames);

    
    filename = '';    
    try
    filename = filenames(bestpos, :);
    catch
    end       
    
    
    if partToUse == 0
        image = images{bestpos};
        description = 'Full Image Used';
    end
    
    if partToUse == 1
        %image = images{bestpos};
         image = imcrop(images{bestpos}, [0 0 newwidth (newheight/2)]);
         image = imresize(image, [newheight newwidth]);
        description = 'Top Half Used';
    end
    
    if partToUse == 2
        %image = images{bestpos};
        image = imcrop(images{bestpos}, [0 (newheight/2) newwidth newheight]);
        image = imresize(image, [newheight newwidth]);
        description = 'Bottom Half Used';
    end
    

end