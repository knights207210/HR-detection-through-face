function [ path_colortraces, path_landmarks ] = extractcolortraces( sVideo,options,i )
%extractcolortraces Summary of this function goes here
%get meanvalues and landmarks of video and return the path
method = options.getParam('facefeaturemethod');
if method == 1    %DRMF
    
    [facial_landmarks] = DRMF_facial_landmarks(sVideo);
    [ROI_boundary_points] = ROI_points(facial_landmarks);
    [transformation_matrix] = get_transformation_matrix(video);
    % calculate color traces, mean value contain frames from 
    % 1st to last one of the video (not lastFrame set as the parameters)
    show = 0;
    [mean_value, pathtolandmarks] = mean_value_calculation(ROI_boundary_points,transformation_matrix,video,show);
    savepath = sprintf('colortraces%d.mat',i);
    % save color traces and their corresponding transformation matrix
    save(savepath,'transformation_matrix','mean_value');  
    path_colortraces = savepath;
    path_landmarks = pathtolandmarks;
    
elseif method == 2      %DILB
    
    VideoFileReader = vision.VideoFileReader(sVideo.path);
    
    for k=1:sVideo.lastFrame+3*sVideo.fps
        frame = step(VideoFileReader);
        facial_landmarks(k) = dilb(frame);
        ROI_boundary_points(k) = ROI_points_dilb(facial_landmarks(k));
        show = 0;
        mean_value(k) = mean_value_cal_dilb(ROI_boundary_points(k),sVideo,show);   
    end
    savepath1 = sprintf('colortraces%d.mat',i);
    save(savepath1,'mean_value');
    path_colortraces = savepath1;
    savepath2 = sprintf('landmarks%d.mat',i);
    save(savepath2,'landmarks');
    path_landmarks = savepath2;
    

end

