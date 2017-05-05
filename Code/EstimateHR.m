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
    [sVideo] = extractColortraces(sVideo,cParams);
end

%% todo plot debug view for roi and landmarks
flag = cParams.getParam('outputvideo');
%% read meanvalues of rois
mean_value = load(sVideo.pathToColorTraces,'mean_value');
sub_mean_value = load(sVideo.pathToColorTraces,'sub_mean_value');
mean_value_correct = load(sVideo.pathToColorTraces,'mean_value_correct');
mean_value_cal{1} = mean_value.mean_value;
for m = 2:3
mean_value_cal{m} = sub_mean_value.sub_mean_value{m-1};
end
mean_value_cal{4}= mean_value_correct.mean_value_correct;
sVideo.lastFrame = length(mean_value_cal{1});
%% PPG signal processing 
for m=1:4
    path = sprintf('%s/data/%s/%d',cd,sVideo.name,m);
    mkdir(path);
    
    [HR{m},result_for_plot{m}] = PPG_processing(mean_value_cal{m},sVideo,cParams);
    
    saveas(gcf,[sVideo.pathToOutput_plot,'/',num2str(m),'/estimateHR_plot.jpg']);
    close(gcf);
    saveas(gcf,[sVideo.pathToOutput_plot,'/',num2str(m),'/detrend_plot.jpg']);
    close(gcf);
    saveas(gcf,[sVideo.pathToOutput_plot,'/',num2str(m),'/motionelimination_plot.jpg']);
    close(gcf);

    HR{m}=HR{m}.*60;
    sResults.vHR{m} = HR{m};
    sResults.averageHR(m) = mean(HR{m}');
    sResults.result_for_plot{m} = result_for_plot{m};
end

%% final output of measurements and video

%% sResults
sResults.sVideo = sVideo;
sResults.cParams = cParams;
sResults.result_for_plot = result_for_plot;
end

