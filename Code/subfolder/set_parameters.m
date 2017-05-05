function [ sVideo,options,CParams ] = set_parameters(options,n)

%% set parameters
flag_calgt = options.getParam('calgt');
flag_calcolortraces = options.getParam('calcolortraces');

if nargin == 1
%% set sVideo

%% only this section needs manually setting
    sVideo.path = sprintf('%s/videos/rotiate_fps30.MP4',cd);                 %video's path
    sVideo.name = 'rotiate_fps30' ;

%% do not need manually setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sVideo.pathToColorTraces = sprintf('');    %video's color traces, added in function EstimateHR
    sVideo.pathToLandmarks = sprintf('');      %video's landmarks, added in function EstimateHR 
    sVideo.pathtoGT =sprintf('');
    sVideo.pathtoECG = sprintf('');
    sVideo.pathtooutput_video = sprintf('');
    sVideo.pathtooutput_figure = sprintf('');
    sVideo.pathtooutput_plot = sprintf('');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path = sprintf('%s/data/%s',cd,sVideo.name);
    mkdir(path);
    path = sprintf('%s/data/%s/tmp',cd,sVideo.name);
    mkdir(path);
%% path to groundtruth

    if flag_calgt == 2        %groundtruth
        sVideo.pathtoGT = sprintf('%s/data/%s/groundtruth.mat',cd,sVideo.name);    %groundtruth's path
    elseif flag_calgt == 1    %calculate the groundtruth
        sVideo.pathtoECG = sprintf('%s/data/%s/ECG.mat',cd,sVideo.name);   %ECG's path
    elseif flag_calgt == 3
        sVideo.pathtoGT = sprintf('%s/data/HCIdata/groundtruth/groundtruth.mat',cd);
    end
    
%% path to output
    sVideo.pathtooutput_video = sprintf('%s/data/%s/%s.avi',cd,sVideo.name);
    sVideo.pathtooutput_figure = sprintf('%s/data/%s/tmp',cd,sVideo.name);
    sVideo.pathtooutput_plot = sprintf('%s/data/%s',cd,sVideo.name);

%%
    videoFileReader = vision.VideoFileReader(sVideo.path);
    S = info(videoFileReader);
    sVideo.fps = S.VideoFrameRate;
   
%% set options
    flag_ppgrecover = 1;      %PPG signal recover method: G[1],PVG[2],XX[3]
    options.addParam('ppgrecover', flag_ppgrecover);

    flag_facefeaturemethod = 2;              %feature method: DRMF[1],DILB[2]
    options.addParam('facefeaturemethod', flag_facefeaturemethod);
    if flag_calcolortraces == 2
        if flag_facefeaturemethod == 1
            sVideo.pathToColorTraces = sprintf('%s/data/%s/colortraces_DRMF1.mat',cd,sVideo.name);  %colortraces' path
            sVideo.pathToLandmarks = sprintf(cd,'%s/data/%s/landmarks_DRMF1.mat',cd,sVideo.name);    %landmarks'path
    
        elseif flag_facefeaturemethod == 2
            sVideo.pathToColorTraces = sprintf('%s/data/%s/colortraces_DLIB1.mat',cd,sVideo.name);  %colortraces' path
            sVideo.pathToLandmarks = sprintf('%s/data/%s/landmarks_DLIB1.mat',cd,sVideo.name);    %landmarks'path
    
        end
    
    end
    
    flag_detrendmethod = 1;                 %detrendmethod[1] or not[2]
    options.addParam('detrendmethod', flag_detrendmethod);
    
%% set CParams
    CParams = C_params('HR extraction Parameter');    %set name
    CParams.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

    % frames from video to extract
    CParams.addParam('videoFramesToExtract', {[round(sVideo.fps) round(10*sVideo.fps)]});

    %normalizing parameters
    meanNormalizationWinLengthInSec     = 0.8*3; % should be at least a pulse period
    meanNormalizationWinLengthInFrames = roundNextOdd(sVideo.fps*meanNormalizationWinLengthInSec); 
    CParams.addParam('meanNormalizationWinLengthInFrames', meanNormalizationWinLengthInFrames);
    %window has to be odd

    %motion elimination parameters
    motionWinlengthInFrames = 15;
    motionWindowShift = floor(motionWinlengthInFrames/2);
    CParams.addParam('motionWinlengthInFrames', motionWinlengthInFrames);
    CParams.addParam('motionWindowShift', motionWindowShift);

    %detrending method parameters
    CParams.addParam('lambda1', 55);
    CParams.addParam('lambda2', 56);

    %threshold percentage
    CParams.addParam('percentage', 0.96);
    CParams.addParam('threshold',0.001973102363443);

    %PSD estimation parameters
    psdWinLengthInSec     = 11;
    psdWinLengthInFrames = round(sVideo.fps*psdWinLengthInSec);
    CParams.addParam('psdWinLengthInSec', psdWinLengthInSec);
    CParams.addParam('psdWinLengthInFrames', psdWinLengthInFrames);
    CParams.addParam('psdWinShift', round(sVideo.fps));

    %additipnal parameters
    extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
    CParams.addParam('videoAdditionalBorderFrames', extraFramesNeeded);
    
    %sVideo
    vector = CParams.getParam('videoFramesToExtract');
    for k = 1:vector(1)-1
    [~]= step(videoFileReader);
    end
    sVideo.firstframe = step(videoFileReader);
    sVideo.firstFrame = vector(1);
    sVideo.lastFrame = vector(2);
    
elseif nargin == 2
    %% set sVideo
    sVideo.path = sprintf('');                 %video's path
    sVideo.pathToColorTraces = sprintf('');    %video's color traces, added in function EstimateHR
    sVideo.pathToLandmarks = sprintf('');      %video's landmarks, added in function EstimateHR 
    
    if flag_calgt == 2        %groundtruth
        sVideo.pathtoGT = sprintf('/home/hanxu/thesis/NewFolder/data/HCIdata/groundtruth');    %groundtruth's path
    elseif flag_calgt == 1    %calculate the groundtruth
        sVideo.pathtoECG = sprintf('/home/hanxu/thesis/NewFolder/data');   %ECG's path
    end
    
    if flag_calcolortraces == 2
    sVideo.pathtocolortraces = sprintf('/home/hanxu/thesis/NewFolder/data/HCIdata/colortraces');  %colortraces' path
    sVideo.pathtolandmarks = sprintf('/home/hanxu/thesis/NewFolder/data/HCIdata/landmarks');    %landmarks'path
    end
    
    %videoFileReader = vision.VideoFileReader(sVideo.path);
    %S = info(videoFileReader);
    sVideo.fps = 61;
   
%% set options
    flag_ppgrecover = 1;      %PPG signal recover method: G[1],PVG[2],XX[3]
    options.addParam('ppgrecover', flag_ppgrecover);

    flag_facefeaturemethod = 1;              %feature method: DRMF[1],DILB[2]
    options.addParam('facefeaturemethod', flag_facefeaturemethod);
        
    flag_detrendmethod = 1;                 %detrendmethod[1] or not[2]
    options.addParam('detrendmethod', flag_detrendmethod);
    
%% set CParams
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
    CParams.addParam('lambda1', 55);
    CParams.addParam('lambda2', 56);

    %threshold percentage
    CParams.addParam('percentage', 0.96);
    CParams.addParam('threshold',0.001973102363443);

    %PSD estimation parameters
    psdWinLengthInSec     = 13;
    psdWinLengthInFrames = round(sVideo.fps*psdWinLengthInSec);
    CParams.addParam('psdWinLengthInSec', psdWinLengthInSec);
    CParams.addParam('psdWinLengthInFrames', psdWinLengthInFrames);
    CParams.addParam('psdWinShift', sVideo.fps);

    %additipnal parameters
    extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
    CParams.addParam('videoAdditionalBorderFrames', extraFramesNeeded);
    %sVideo
    vector = CParams.getParam('videoFramesToExtract');
    %for k = 1:vector(1)-1
    %[~]= step(videoFileReader);
    %end
    %sVideo.firstframe = step(videoFileReader);
    sVideo.firstFrame = vector(1);
    sVideo.lastFrame = vector(2);
end

end

