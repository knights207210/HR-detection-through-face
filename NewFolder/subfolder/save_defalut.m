CParams = C_params('HR extraction Parameter');    %set name
    CParams.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

    % frames from video to extract
    CParams.addParam('videoFramesToExtract', {[306 2135]});

    %normalizing parameters
    meanNormalizationWinLengthInSec     = 0.8*3; % should be at least a pulse period
    meanNormalizationWinLengthInFrames = roundNextOdd(61*meanNormalizationWinLengthInSec); 
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
    psdWinLengthInFrames = round(61*psdWinLengthInSec);
    CParams.addParam('psdWinLengthInSec', psdWinLengthInSec);
    CParams.addParam('psdWinLengthInFrames', psdWinLengthInFrames);
    CParams.addParam('psdWinShift', 61);

    %additipnal parameters
    extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
    CParams.addParam('videoAdditionalBorderFrames', extraFramesNeeded);
    
    savepath = sprintf('/home/hanxu/thesis/NewFolder/data/defalut.mat');
    save(savepath,'CParams');
    