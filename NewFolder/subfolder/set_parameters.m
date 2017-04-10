function [ CParams ] = set_parameters

%% set parameters

    CParams = C_params('HR extraction Parameter');    %set name
    CParams.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

% frames from video to extract
    flag_videoframestart = input('video frame start(defalut is 306):\n');
    flag_videoframeend = input('video frame end(defalut is 2135):\n');
    CParams.addParam('videoFramesToExtract', {[flag_videoframestart flag_videoframeend]});
    %CParams.addParam('videoFramesToExtract', {[306 2135]});

%normalizing parameters
    flag_meanNormalizationWinLengthInSec = input('the window length when normalizing the mean values in sec(defalut is 0.8*3):\n Note: the window has to be odd');
    %meanNormalizationWinLengthInSec     = 0.8*3; % should be at least a pulse period
    meanNormalizationWinLengthInFrames = roundNextOdd(sVideo.fps*flag_meanNormalizationWinLengthInSec); 
    CParams.addParam('meanNormalizationWinLengthInFrames', meanNormalizationWinLengthInFrames);
    %window has to be odd

%motion elimination parameters
    flag_motionWinlengthInFrames = input('the window length when eliminate the motion influences in frames(defalut is 31):\n');
    %motionWinlengthInFrames = 31;
    motionWinlengthInFrames = flag_motionWinlengthInFrames;
    motionWindowShift = floor(motionWinlengthInFrames/2);
    CParams.addParam('motionWinlengthInFrames', motionWinlengthInFrames);
    CParams.addParam('motionWindowShift', motionWindowShift);

%detrending method parameters
    flag_lambda1 = input('lambda1(defalut is 55):\n');
    flag_lambda2 = input('lambda2(defalut is 56):\n');
    %lambda1 = 55;
    %lambda2 = 56;
    CParams.addParam('lambda1', flag_lambda1);
    CParams.addParam('lambda2', flag_lambda2);

%threshold percentage
    flag_percentage = input('percentage(defalut is 0.96):\n');
    %percentage = 0.96;
    CParams.addParam('percentage', flag_percentage);
    
    flag_threshold = input('threshold(defalut is 0.0197):\n');
    %threshold = 0.001973102363443;
    CParams.addParam('threshold',flag_threshold);

%PSD estimation parameters
    flag_psdWinLengthInSec = input('PSD estimation window length in sec(defalut is 13):\n');
    %psdWinLengthInSec     = 13;
    psdWinLengthInSec = flag_psdWinLengthInSec;
    psdWinLengthInFrames = round(sVideo.fps*psdWinLengthInSec);
    psdWinShift = sVideo.fps;
    CParams.addParam('psdWinLengthInSec', psdWinLengthInSec);
    CParams.addParam('psdWinLengthInFrames', psdWinLengthInFrames);
    CParams.addParam('psdWinShift', psdWinShift);

%additipnal parameters
    extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
    CParams.addParam('videoAdditionalBorderFrames', extraFramesNeeded);
end

