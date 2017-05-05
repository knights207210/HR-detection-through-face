function [ mean_value] = mean_value_calculation(ROI_boundary_points,transformation_matrix_f,video,show)
%
%
%old_ROI_boundary_points=ROI_boundary_points;
%numFrames = video.numFrames;


%% tracking in both directions
%c=1;
%for n=video.initFrame:numFrames
  %videoFrame =  video.frames(n).data;
  %if n==video.initFrame
    % the 1st frame has no need to transform, directly compute mean value
    %mean_value(n,:) = average_ROI(videoFrame,old_ROI_boundary_points,show);
  %else
    % transform ROI from the previous frame to the successive frame
    %new_ROI_boundary_points = transformPointsForward(transformation_matrix_f{c-1},old_ROI_boundary_points);
    %mean_value(n,:) = average_ROI(videoFrame,new_ROI_boundary_points,show);
    %old_ROI_boundary_points=new_ROI_boundary_points;
  %end
  %c=c+1;
%end
%c=1;
%for n=video.initFrame-1:-1:1
  %videoFrame =  video.frames(n).data;
  % transform ROI from the previous frame to the successive frame
  %new_ROI_boundary_points = transformPointsForward(transformation_matrix_b{c},old_ROI_boundary_points);
  %mean_value(n,:) = average_ROI(videoFrame,new_ROI_boundary_points,show);
  %old_ROI_boundary_points=new_ROI_boundary_points;
  
  %c=c+1;
%end

%end%fun

videoFileReader = vision.VideoFileReader(video.path);
old_ROI_boundary_points=ROI_boundary_points;

for n=1:video.lastFrame+32*video.fps
    videoFrame = step(videoFileReader);
    if n==1
        % the 1st frame has no need to transform, directly compute mean value
        mean_value(n,:) = average_ROI(videoFrame,old_ROI_boundary_points,show);
    else
        % transform ROI from the previous frame to the successive frame 
        new_ROI_boundary_points = transformPointsForward(transformation_matrix_f{n-1},old_ROI_boundary_points);
        mean_value(n,:) = average_ROI(videoFrame,new_ROI_boundary_points,show);
        old_ROI_boundary_points=new_ROI_boundary_points;
    end
end
release(videoFileReader);
end