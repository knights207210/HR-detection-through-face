%% calculate the average HR for a video
clc;
clear;

addpath('subfolder');
sVideo.path = '/home/hanxu/thesis/videos/withglass_fps60.MP4';
cParams = C_params('hr options');

cParams.addParam('calcLandmarks',0);
cParams.addParam('calcColortraces',0);
cParams.addParam('useMotionElemination',1); % todo fix motion elemination
%cParams.addParam('videoFramesToExtract',{[30,300]});
cParams.addParam('outputvideo',0);

sResult = EstimateHR(sVideo,cParams);

output_videoprocessed(sResult);

%-> it should be that simple to calculate HR
% here we don't set any options and EstimateHR will use the default options