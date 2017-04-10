%% calculate the average HR for a video
sVideo.path = 'myVideo.mp4';

averageHR = EstimateHR(sVideo);

%-> it should be that simple to calculate HR
% here we don't set any options and EstimateHR will use the default options