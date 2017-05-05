function [count] = output_videoprocessed(frame,facial_landmarks,j,n,sResult,count)
%output_videoprocessed Summary of this function goes here
%this function is used to figure and for testing the results; to have a
%better visulization effect
%%output video or not
    
%% calculate and store the image
        points = facial_landmarks;
        pointImage = insertMarker(frame,points,'+','Color','white');
        ROI_boundary_points = ROI_points_dilb(points);
        ROI_points = ROI_boundary_points;
        ROI_boundarypointImage = insertMarker(pointImage,ROI_points,'*','Color','red');

try
    mean_value = average_ROI(frame,ROI_boundary_points,0);
catch
    close(gcf);
    return;
end
if j== 0     %% mean_value
    
    
        ROI_points = round(fliplr(ROI_points));
elseif j==1  %% sub region 1
        ROI_boundary_points_left = [ROI_boundary_points(1,1),ROI_boundary_points(1,2);...
                     ROI_boundary_points(2,1),ROI_boundary_points(2,2);...
                     ROI_boundary_points(3,1),ROI_boundary_points(3,2);...
                     ROI_boundary_points(4,1),ROI_boundary_points(4,2);...
                     ROI_boundary_points(10,1),ROI_boundary_points(10,2)];
        ROI_points = round(fliplr(ROI_boundary_points_left));
elseif j==2  %% sub region 2
        ROI_boundary_points_right = [ROI_boundary_points(5,1),ROI_boundary_points(5,2);...
                     ROI_boundary_points(6,1),ROI_boundary_points(6,2);...
                     ROI_boundary_points(7,1),ROI_boundary_points(7,2);...
                     ROI_boundary_points(8,1),ROI_boundary_points(8,2);...
                     ROI_boundary_points(9,1),ROI_boundary_points(9,2)];
        ROI_points = round(fliplr(ROI_boundary_points_right));
elseif j==3  %% region correct
        ROI_points = round(fliplr(ROI_points));
        if (n>127)&(n<216)
            ROI_boundary_points_left = [ROI_boundary_points(1,1),ROI_boundary_points(1,2);...
                     ROI_boundary_points(2,1),ROI_boundary_points(2,2);...
                     ROI_boundary_points(3,1),ROI_boundary_points(3,2);...
                     ROI_boundary_points(4,1),ROI_boundary_points(4,2);...
                     ROI_boundary_points(10,1),ROI_boundary_points(10,2)];
            ROI_points = round(fliplr(ROI_boundary_points_left));
        elseif (n>248)&(n<334)
            ROI_boundary_points_right = [ROI_boundary_points(5,1),ROI_boundary_points(5,2);...
                     ROI_boundary_points(6,1),ROI_boundary_points(6,2);...
                     ROI_boundary_points(7,1),ROI_boundary_points(7,2);...
                     ROI_boundary_points(8,1),ROI_boundary_points(8,2);...
                     ROI_boundary_points(9,1),ROI_boundary_points(9,2)];
            ROI_points = round(fliplr(ROI_boundary_points_right)); 
        end
end
        frame = double(ROI_boundarypointImage);
        [H,W,~] = size(ROI_boundarypointImage);
        % the following is trying to judge which pixel is inside ROI. 'inpolygon.m'
        % makes the judgement. I first narrow the region to reduce computation. 
        maxwidth = round(max(ROI_points(:,2)));
        minwidth = round(min(ROI_points(:,2)));
        maxheight = round(max(ROI_points(:,1)));
        minheight = round(min(ROI_points(:,1)));
        if maxheight>H
            maxheight = H;
        end
        
        im_X = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
        im_Y = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
        for h=1:maxheight-minheight+1
            im_X(h,:) = minheight+h-1;
            im_Y(h,:) = minwidth:maxwidth;
        end
        IN_face = inpolygon(im_X,im_Y,[ROI_points(:,1);ROI_points(1,1)],[ROI_points(:,2);ROI_points(1,2)]);
        mask_image = zeros(H,W);
        mask_image(minheight:maxheight,minwidth:maxwidth) = IN_face;
        inverse_mask_image=~mask_image;
        test_image(:,:,1)=inverse_mask_image.*ROI_boundarypointImage(:,:,1);
        test_image(:,:,2)=inverse_mask_image.*ROI_boundarypointImage(:,:,2);
        test_image(:,:,3)=inverse_mask_image.*ROI_boundarypointImage(:,:,3);
        % test_image=uint8(test_image);
        subplot(4,1,1,'position',[0.05,0.5,0.9,0.5]);
        imshow(test_image);
        savepath = sprintf('%s/data/%s/Figures/%d/%d.jpg',cd,sResult.sVideo.name,j+1,count-sResult.sVideo.firstFrame);
        set(gcf,'Position',[80 100 1500 1000]);
        saveas(gcf,[savepath]);
        close(gcf);
        count = count+1;
end        
        
 



 


 
            
    



