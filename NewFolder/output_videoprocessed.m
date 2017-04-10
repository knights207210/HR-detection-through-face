function [] = output_videoprocessed
%output_videoprocessed Summary of this function goes here
%this function is used to figure and for testing the results; to have a
%better visulization effect

%flag1 = options.getopt('inputtype');
%flag2 = options.getopt('facefeaturemethod');
%path_video = sResults.path;
%path_landmarks = sResults.pathToLandmarks;
%load(path_video);
flag1 = 1;
flag2 = 1;
path_video = '1.avi';
path_landmarks = 'landmarks1.mat';
path_colortraces = 'colortraces1.mat';
load(path_landmarks);
load(path_colortraces);
lastframe = 10*61;


%% calculate and store the image 
if flag1 == 1   %single video
    if flag2 ==1     %DRMF
        VideoFileReader = vision.VideoFileReader(path_video);
        frame = step(VideoFileReader);
        points = facial_landmarks.points;
        pointImage = insertMarker(frame,points,'+','Color','white');
        imshow(pointImage);
        saveas(gcf,['/Users/hanxu/Desktop/thesis/NewFolder/tmp/','single video',num2str(1),'.jpg']);
        %export_fig(['/tmp/1.png']);
        
        for k=2:lastframe
            frame = step(VideoFileReader);
            oldpoints = points;
            newpoints = transformPointsForward(transformation_matrix{k-1},oldpoints);
            points = newpoints;
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            saveas(gcf,['/Users/hanxu/Desktop/thesis/NewFolder/tmp/','single video',num2str(k),'.jpg']);
        end
    elseif flag2 == 2    %DILB
        for k = 1:sResults.outframe
            VideoFileReader = vision.VideoFileReader(video_path);
            frame = step(VideoFileReader);
            points = landmarks(k);
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            export_fig(['/tmp/%d.png',k]);
        end
    end

elseif flag1 == 2     %databases
    for m = 1:length(sResults)
     if flag2 ==1     %DRMF
        VideoFileReader = vision.VideoFileReader(path_video);
        frame = step(VideoFileReader);
        points = landmarks;
        pointImage = insertMarker(frame,points,'+','Color','white');
        imshow(pointImage);
        export_fig(['/tmp/%d_1.png',m]);
        
        for k=2:sResults.outframe
            frame = step(frame);
            oldpoints = points;
            newpoints = transformPointsForward(transformation_matrix{k-1},oldpoints);
            points = newpoints;
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            export_fig(['/tmp/%d_%d.png',m,k]);
        end
     elseif flag2 == 2    %DILB
        for k = 1:sResults.outframe
            VideoFileReader = vision.VideoFileReader(video_path);
            frame = step(VideoFileReader);
            points = landmarks(k);
            pointImage = insertMarker(frame,points,'+','Color','white');
            imshow(pointImage);
            export_fig(['/tmp/%d_%d.png',m,k]);
        end
     end   
    end

end
 
%% output video

            
    


end

