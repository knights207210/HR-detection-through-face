function [ sResults ] = EstimateHR( sVideo, options, CParams)
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
%   -options:to decide which method to use/ which step to use
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
%     sResults.video.pathToLandmarks
%     sResults.video.pathToColorTraces
%     % HR estimation results
%     sResults.averageHR
%     sResults.averageHR_GT 
%     % some statistics
%     sResults.afterMotionElimination

%%
addpath('subfolder');

%% groundtruth
flag_gt = options.getParam('calgt');
if flag_gt == 1    %calculate the groundtruth
    global pathtoECG
    global i

    sResults.averageHR_GT = cal_gt(pathtoECG,i);

elseif flag_gt == 2   %import the gt
    
    sResults.averageHR_GT = groundtruth(i);
end
    

%% extract color traces
if nargin == 2
    options.addParam('facefeaturemethod',1);
    options.addParam('ppgrecover',1);
end 

flag_colortraces = options.getParam('calcolortraces');
if flag_colortraces == 1
    [path_colortraces, path_landmarks] = extractcolortraces(sVideo,options,i);
    sVideo.pathToColorTraces = path_colortraces;
    sVideo.pathToLandmarks = path_landmarks;
    
elseif flag_colortraces == 2
    sVideo.pathToColorTraces = colortraces(i);
    sVideo.pathToLandmarks = landmarks(i);
end



%% if three input arguments(with CParams)
if nargin == 3
    
    %% read meanvalues
    savepath = sVideo.pathToColorTraces;
    mean_value = load(savepath,'mean_value');
    mean_value = mean_value.mean_value;

%% PPG signal processing (could choose method)
    [HR,afterMotionElimination] = PPG_processing(mean_value,sVideo,CParams,options);
    HR = HR.*60;
    sResults.averageHR = mean(HR');

%% sResults
    sResults.path = sVideo.path;
    sResults.pathToLandmarks = sVideo.pathToLandmarks;
    sResults.pathToColorTraces = sVideo.pathToColorTraces;
    sResults.pathToSD = sVideo.pathToSD;
    sResults.afterMotionElimination = afterMotionElimination;   %rstore the signal after motion elimination
    
%% if two input arguments(no CParams) 
elseif nargin == 2            %use defalut parameters

%% set parameters
    
    CParams = C_params('HR extraction Parameter');    %set name
    CParams.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

% frames from video to extract
    CParams.addParam('videoFramesToExtract', {[306 2135]});

%normalizing parameters
    meanNormalizationWinLengthInSec     = 0.8*3; % should be at least a pulse period
    meanNormalizationWinLengthInFrames = roundNextOdd(sVideo.fps*meanNormalizationWinLengthInSec); 
    CParams.addParam('meanNormalizationWinLengthInFrames', meanNormalizationWinLengthInFrames);
%window has to be odd

%motion elimination parameters
    motionWinlengthInFrames = 31;
    motionWindowShift = floor(motionWinlengthInFrames/2);
    CParams.addParam('motionWinlengthInFrames', motionWinlengthInFrames);
    CParams.addParam('motionWindowShift', motionWindowShift);

%detrending method parameters
    lambda1 = 55;
    lambda2 = 56;
    CParams.addParam('lambda1', lambda1);
    CParams.addParam('lambda2', lambda2);

%threshold percentage
    percentage = 0.96;
    CParams.addParam('percentage', percentage);
    threshold = 0.001973102363443;
    CParams.addParam('threshold',threshold);

%PSD estimation parameters
    psdWinLengthInSec     = 13;
    psdWinLengthInFrames = round(videofps*13);
    psdWinShift = videofps;
    CParams.addParam('psdWinLengthInSec', psdWinLengthInSec);
    CParams.addParam('psdWinLengthInFrames', psdWinLengthInFrames);
    CParams.addParam('psdWinShift', psdWinShift);

%additipnal parameters
    extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
    CParams.addParam('videoAdditionalBorderFrames', extraFramesNeeded);


%% read meanvalues
    savepath = sVideo.pathToColorTraces;
    mean_value = load(savepath,'mean_value');
    mean_value = mean_value.mean_value;

%% PPG signal processing (could choose method)
    [HR,afterMotionElimination] = PPG_processing(mean_value,sVideo,CParams,ooptions);
    HR = HR.*60;
    sResults.averageHR = mean(HR');

%% sResults
    sResults.path = sVideo.path;
    sResults.pathToLandmarks = sVideo.pathToLandmarks;
    sResults.pathToColorTraces = sVideo.pathToColorTraces;
    sResults.pathToSD = sVideo.pathToSD;
    sResults.afterMotionElimination = afterMotionElimination;   %rstore the signal after motion elimination
end
%% check options and load default if nothing was set

%% load video...

%% ... 


end

