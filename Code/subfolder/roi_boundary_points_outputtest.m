 path_video = sResult.sVideo.path;
    path_landmarks = sResult.sVideo.pathToLandmarks;
    path_colortraces = sResult.sVideo.pathToColorTraces;
    load(path_landmarks);
    load(path_colortraces);
        
    m=0;
    VideoFileReader = vision.VideoFileReader(path_video);
        
    for k =1:sResult.sVideo.firstFrame-1
            [~] = step(VideoFileReader);
    end
    
    for k = sResult.sVideo.firstFrame:sResult.sVideo.lastFrame
        m=m+1;
        frame = step(VideoFileReader);
        points = facial_landmarks{k};
        pointImage = insertMarker(frame,points,'+','Color','white')
        ROI_boundary_points = ROI_points_dilb(points);
        ROI_points = ROI_boundary_points;
        ROI_boundarypointImage = insertMarker(pointImage,ROI_points,'*','Color','red');
        %signalpoints = [k-sResults.firstFrame+1, 200*sResults.normalizedsignal(k)];
        %pointImage = insertMarker(pointImage, signalpoints,'*','Color','red');
        imshow(ROI_boundarypointImage);
        %axis on;
        savepath = sprintf('%s/data/%s/Figures/%d.jpg',cd,sResult.sVideo.name,m-1);
        saveas(gcf,[savepath]);
    end