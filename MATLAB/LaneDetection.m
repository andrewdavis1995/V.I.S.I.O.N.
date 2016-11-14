
function LaneDetection(img)
    [H,theta,rho] = hough(img);
    peaks = houghpeaks(H,2);
    lines = houghlines(img,theta, rho, peaks, 'FillGap', 30,'MinLength', 100);
    
    for k = 1:length(lines)
        arrow(lines(k).point1, lines(k).point2, 'EdgeColor', 'g', 'FaceColor', 'g', 'LineWidth',2);
    end
    
end