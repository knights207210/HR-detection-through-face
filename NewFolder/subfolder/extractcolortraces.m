function [ path_colortraces, path_landmarks ] = extractcolortraces( sVideo,options,i )
%extractcolortraces Summary of this function goes here
%get meanvalues and landmarks of video and return the path
method = options.getParam('facefeaturemethod');
if method == 1    %DRMF
    
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
    
elseif method == 2      %DILB
    addpath('/home/hanxu/thesis/NewFolder/subfolder/Package');
    
    VideoFileReader = vision.VideoFileReader(sVideo.path);
    for k=1:sVideo.firstFrame-1
        [~]=step(VideoFileReader);
    end
    
    for k=sVideo.firstFrame:sVideo.lastFrame+20*sVideo.fps
        frame = step(VideoFileReader);
        frame = im2uint8(frame);
        facial_landmarks{k} = dlibLandmarks('/home/hanxu/thesis/NewFolder/subfolder/Package/model.dat',frame);
        ROI_boundary_points{k} = ROI_points_dilb(facial_landmarks{k});
        show = 0;
        mean_value(k,:) = average_ROI(frame,ROI_boundary_points{k},show);
    end
    savepath1 = sprintf('%s/data/%s/colortraces_DLIB%d.mat',cd,sVideo.name,i);
    save(savepath1,'mean_value');
    path_colortraces = savepath1;
    savepath2 = sprintf('%s/data/%s/landmarks_DLIB%d.mat',cd,sVideo.name,i);
    save(savepath2,'facial_landmarks');
    path_landmarks = savepath2;
    

end

