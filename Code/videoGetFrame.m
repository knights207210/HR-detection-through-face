function [ frame ] = videoGetFrame( path,frameNr )
%VIDEOGETFRAME 
videoFileReader = VideoReader(path);
for k = 1:frameNr
    frame = readFrame(videoFileReader);
end

end

