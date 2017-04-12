function [] = output_videoprocessed(sResults,options)
%output_videoprocessed Summary of this function goes here
%this function is used to figure and for testing the results; to have a
%better visulization effect

flag1 = options.getParam('inputtype');
flag2 = options.getParam('facefeaturemethod');


%% calculate and store the image 
if flag1 == 1   %single video
path_video = sResults.path;
path_landmarks = sResults.pathToLandmarks;
path_colortraces = sResults.pathToColorTraces;
load(path_landmarks);
load(path_colortraces);

    if flag2 ==1     %DRMF
        VideoFileReader = vision.VideoFileReader(path_video);
        for k=1:sResults.firstFrame-1
            [~]=step(VideoFileReader);
        end
        frame = step(VideoFileReader);
        points = facial_landmarks.points;
        pointImage = insertMarker(frame,points,'+','Color','white');
        imshow(pointImage);
        savepath = sprintf('%s/data/%s/tmp/%d.jpg',cd,sResults.name,0);
        saveas(gcf,[savepath]);
        m=0;
        for k=sResults.firstFrame+1:sResults.lastFrame
            m=m+1;
            frame = step(VideoFileReader);
            oldpoints = points;
            newpoints = transformPointsForward(transformation_matrix{k-1},oldpoints);
            points = newpoints;
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            savepath = sprintf('%s/data/%s/tmp/%d.jpg',cd,sResults.name,m);
            saveas(gcf,[savepath]);
        end
    elseif flag2 == 2    %DILB
        path_video = sResults.path;
        path_landmarks = sResults.pathToLandmarks;
        path_colortraces = sResults.pathToColorTraces;
        load(path_landmarks);
        load(path_colortraces);
        m=0;
        VideoFileReader = vision.VideoFileReader(path_video);
        for k =1:sResults.firstFrame-1
            [~] = step(VideoFileReader);
        end
        for k = sResults.firstFrame:sResults.lastFrame
            m=m+1;
            frame = step(VideoFileReader);
            points = facial_landmarks{k};
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            savepath = sprintf('%s/data/%s/tmp/%d.jpg',cd,sResults.name,m-1);
            saveas(gcf,[savepath]);
        end
    end
%% output video
 picFormat = 'jpg';
 syscall = ['ffmpeg -f image2 -i ' cd,'/data/',sResults.name,'/tmp/%d.',picFormat,' -r ',num2str(sResults.fps),' ',sResults.name,'.avi'];
 [status,cmdout] = system(syscall,'-echo');
        

elseif flag1 == 2     %databases
    for m = 1:length(sResults)
        path_video = sResults{m}.path;
        path_landmarks = sResults{m}.pathToLandmarks;
        path_colortraces = sResults{m}.pathToColorTraces;
        load(path_landmarks);
        load(path_colortraces);

     if flag2 ==1     %DRMF
        VideoFileReader = vision.VideoFileReader(path_video);
        frame = step(VideoFileReader);
        points = facial_landmarks.points;
        pointImage = insertMarker(frame,points,'+','Color','white');
        imshow(pointImage);
        path = sprintf('/home/hanxu/thesis/NewFolder/data/tmp/dataset%d',m);
        mkdir(path);
        saveas(gcf,['/home/hanxu/thesis/NewFolder/data/tmp/dataset',num2str(m),'/',num2str(0),'.jpg']);
        
        %for k=2:sResults{m}.lastFrame
         for k=2:610
            frame = step(VideoFileReader);
            oldpoints = points;
            newpoints = transformPointsForward(transformation_matrix{k-1},oldpoints);
            points = newpoints;
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            saveas(gcf,['/home/hanxu/thesis/NewFolder/data/tmp/dataset',num2str(m),'/',num2str(k-1),'.jpg']);
        end
     elseif flag2 == 2    %DILB
        for k = 1:sResults{m}.lastFrame
            VideoFileReader = vision.VideoFileReader(path_video);
            frame = step(VideoFileReader);
            points = landmarks(k);
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            path = sprintf('/home/hanxu/thesis/NewFolder/data/tmp/dataset%d',m);
            mkdir(path);
            saveas(gcf,['/home/hanxu/thesis/NewFolder/data/tmp/dataset',num2str(m),'/',num2str(k-1),'.jpg']);
        end
     end 
     picFormat = 'jpg';
     syscall = ['ffmpeg -f image2 -i /home/hanxu/thesis/NewFolder/data/tmp/dataset',num2str(m),'/%d.',picFormat,' -r ',num2str(sResults{m}.fps),' ',num2str(m),'.avi'];
    [status,cmdout] = system(syscall,'-echo');
    end

end
 


 
            
    


end

