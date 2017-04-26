function [ sResults ] = EstimateHR( sVideo, cParams)
%ESTIMATEHR 
% function to calculate heart rate from a video, calculte
% groundtruth(optional)&colortraces(optional)
% 
% input: 
%   -sVideo: is a matlab struct containing the following 
%     sVideo.fps = fps of video
%     sVideo.path = path to video
%     sVideo.pathToLandmarks        % path to a matfile with landmarks   
%     sVideo.pathToColorTraces      % path to a matfile with colortraces
%     --> paths to matfiles are optional
%     sVideo.inFrame  % range of frames to use for HR estimation
%     sVideo.outFrame % 
%     ...
%
%
%   -CParams:cParams class (optional, otherwise we use default settings)
%   including lambda, percentage, threshold
%     parameters:
%     - 
%      ...
%
% output:
%   -averageHR % the average heart rate estimated
%   -sResults - struct with output
%     % paths to saved files and the video (can be used for later calls)
%     sResults.path 
%     sResults.svVdeo.pathToLandmarks
%     sResults.sVideo.pathToColorTraces
%     % HR estimation results
%     sResults.averageHR
%     sResults.averageHR_GT 
%     % some statistics
%     sResults.afterMotionElimination
%     sResults.usedParameters
%

addpath('subfolder');

%% parse input parameters and set sVideo paths etc
if(nargin ==2)
  [ sVideo,cParams ] = setHRParameters( sVideo, cParams );
else
  [ sVideo,cParams ] = setHRParameters( sVideo );
end
%% groundtruth --> 
% designing the creation and loading of ground truth 
% inside an estimation function is bad practise -> evaluation of results
% should be done in a seperate function after calling EstimateHR
% (seperate method and evaluation! of the method)


%% face tracking (landmark detection and roi)
if cParams.getParam('calcLandmarks') == 1
  sVideo.alreadyGotLandmarks = 0;
  %% todo do landmarking in a seperate function (with debug output) 
  %faceTracking(sVideo,cParams);
else
  sVideo.alreadyGotLandmarks = 1;
end

%% extract color traces
if cParams.getParam('calcColortraces') == 1
    extractColortraces(sVideo,cParams);
end

%% todo plot debug view for roi and landmarks

%% read meanvalues of rois
mean_value = load(sVideo.pathToColorTraces,'mean_value');
sub_mean_value = load(sVideo.pathToColorTraces,'sub_mean_value');
mean_value = mean_value.mean_value;
sub_mean_value = sub_mean_value.sub_mean_value;

%% PPG signal processing 
[HR,sVideo] = PPG_processing(mean_value,sVideo,cParams);
saveas(gcf,[sVideo.pathToOutput_plot,'/','motionelimination_plot.jpg']);
close(gcf);
HR = HR.*60;
sResults.vHR = HR;
sResults.averageHR = mean(HR');
%%sub region
for m =1:2
    [HR_sub{m},svideo] = PPG_processing(sub_mean_value{m},sVideo,cParams);
    saveas(gcf,[sVideo.pathToOutput_plot,'/','motionelimination_plot_sub',num2str(m),'.jpg']);
    close(gcf);
    HR_sub{m}=HR_sub{m}.*60;
    sResults.vHR_sub{m} = HR_sub{m};
    sResults.averageHR_sub(m) = mean(HR_sub{m}');
end
%% final output of measurements and video

%% sResults
sResults.sVideo = sVideo;
sResults.cParams = cParams;
end

