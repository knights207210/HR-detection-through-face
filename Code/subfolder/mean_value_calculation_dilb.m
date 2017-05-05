function [ mean_value ] = mean_value_calculation_dilb( ROI_boundary_points,video,show )
%%
videoFileReader = vision.VideoFileReader(video.path);
for k =1:video.firstFrame-1
    [~] = step(videoFileReader);
end

for n= 1:video.lastFrame+32*video.fps
    videoFrame = step(videoFileReader);
    mean_value(n,:) = average_ROI(videoFrame,ROI_boundary_points,show);
end

release(videoFileReader);


end

