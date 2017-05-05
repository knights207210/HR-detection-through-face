function [sVideo] = extractColortraces( sVideo,options)
%extractcolortraces Summary of this function goes here
%get meanvalues and landmarks of video and return the path

%get related param
factor = options.getParam('multiply_factor_for_rectify');

% load the landmarks
if(sVideo.alreadyGotLandmarks == 1)
  load(sVideo.pathToLandmarks,'facial_landmarks');
end

method = options.getParam('faceTrackingMethod');
if strcmp(method,'drmf') == 1    %DRMF
    %Todo update code; still old code (see dlib for new version)
    [facial_landmarks] = DRMF_facial_landmarks(sVideo);
    [ROI_boundary_points] = HR_getROI_points(facial_landmarks);
    [transformation_matrix] = get_transformation_matrix(sVideo);
    % calculate color traces, mean value contain frames from 
    % 1st to last one of the video (not lastFrame set as the parameters)
    show = 0;
    [mean_value] = mean_value_calculation(ROI_boundary_points,transformation_matrix,sVideo,show);
    savepath1 = sprintf('%s/data/%s/colortraces_DRMF%d.mat',cd,sVideo.name,i);
    
    % save color traces and their corresponding transformation matrix
    save(savepath1,'transformation_matrix','mean_value');  
    path_colortraces = savepath1;
    savepath2 = sprintf('%s/data/%s/landmarks_DRMF%d.mat',cd,sVideo.name,i);
    save(savepath2,'facial_landmarks');
    path_landmarks = savepath2;
    %path_landmarks = pathtolandmarks;
    
elseif strcmp(method,'dlib') == 1      %DILB
    addpath('/home/hanxu/thesis/NewFolder/subfolder/Package');
    
    VideoFileReader = VideoReader(sVideo.path);
    % step
    for k=1:sVideo.firstFrame-1
        [~]=readFrame(VideoFileReader);
    end
    
    disp('why +20 seconds, TODO wrong frame reading');
    disp('TODO 2, add dlib output, to see if no face is detected');
    lastFrameStr = num2str(sVideo.lastFrame);
    for k=sVideo.firstFrame:sVideo.lastFrame
      disp([num2str(k) ' of ' lastFrameStr]);
      try
        frame = readFrame(VideoFileReader);
      catch
        disp('no more frames...');
        continue;
      end

        frame = im2uint8(frame);
        if(sVideo.alreadyGotLandmarks == 0)
          facial_landmarks{k} = dlibLandmarks([cd '/subfolder/Package/model.dat'],frame);
        end
        points = facial_landmarks{k};
        pointImage = insertMarker(frame,points,'+','Color','white');
        imshow(pointImage);
        ROI_boundary_points{k} = ROI_points_dilb(facial_landmarks{k});
        
        show = 0;
        
        try
            mean_value(k,:) = average_ROI(frame,ROI_boundary_points{k},show);
        catch
            mean_value(k,:) = 0;
            disp('no face detected');
        end
        
        for m = 1:2   %the number of sub region can be changed
            try
                sub_mean_value{m}(k,:) = sub_average_ROI(frame,ROI_boundary_points{k},m-1);
                
            catch
                sub_mean_value{m}(k,:) = 0;
                disp('no face detected');  
            end
        end
        
        mean_value_correct(k,:) = rectify_meanvalue(mean_value(k,:),sub_mean_value,facial_landmarks{k},factor,k);
        
    end
    mean_value(find(mean_value==0))=[];
    mean_value = reshape(mean_value,length(mean_value)/3,3);
    mean_value_correct(find(mean_value_correct==0))=[];
    mean_value_correct = reshape(mean_value_correct,length(mean_value_correct)/3,3);
    for m =1:2
        sub_mean_value{m}(find(sub_mean_value{m}==0))=[];
        sub_mean_value{m} = reshape(sub_mean_value{m},length(sub_mean_value{m})/3,3);
    end
    
    save(sVideo.pathToColorTraces,'mean_value','sub_mean_value','mean_value_correct');
    
    if(sVideo.alreadyGotLandmarks == 0)
        save(sVideo.pathToLandmarks,'facial_landmarks','ROI_boundary_points');
    end
    sVideo.lastFrame = length(mean_value);
end

