function [ sVideo,cParams ] = setHRParameters( sVideo, cParamsInput )

if(nargin < 2)
  %create input 
  cParamsInput = C_params('HR estimation parameter');
  cParamsInput.sDate = datestr(now,'dd-mm-yy_HH-MM'); 
end
% clone the other settings from cParamsInput
cParams = C_params(cParamsInput.sName);
cParams.sDate = cParamsInput.sDate;

for i = 1:cParamsInput.getParamLength()
  parameterName = cParamsInput.cNames{i};
  parameterValue = cParamsInput.cParams{i};
  cParams.addParam(parameterName,parameterValue);
end

%% now add all other parameters (if not already something else was defined)

% calculate the landmarks and tracking #calcLandmarks
if(cParams.exists('calcLandmarks') == 0)
  cParams.addParam('calcLandmarks',1);
end

% calculate the colortraces #calcColortraces
if(cParams.exists('calcColortraces') == 0)
  cParams.addParam('calcColortraces',1);
end

% fps and first and last frame
% TODO try VideoReader instead uses new gestreamer 1.0
%videoFileReader = vision.VideoFileReader(sVideo.path);
videoFileReader = VideoReader(sVideo.path);
fps = videoFileReader.FrameRate;

if(isfield(sVideo,'fps') == 1)
  disp(['set fps ' num2str(sVideo.fps) ' detected ' num2str(fps)]);
  fps = sVideo.fps;
else
  disp(['Detected fps ' num2str(fps)]);
  sVideo.fps = fps;
end
cParams.addParam('fps',fps); %TODO check if already set

%% first and last frame
if(cParams.exists('videoFramesToExtract') == 4)
  vector = cParams.getParam('videoFramesToExtract');
  fframe = vector(1);
  lframe = vector(2);
else
  fframe = 1;
  lframe = 0;
  while hasFrame(videoFileReader)
    readFrame(videoFileReader);
    lframe=lframe+1;
  end
  disp(['Detected last frame ' num2str(lframe)]);
end
if(isfield(sVideo,'firstFrame') == 0)
    warning('firstFrame in sVideo overwritten');
end
if(isfield(sVideo,'lastFrame') == 0)
    warning('lastFrame in sVideo overwritten');
end
sVideo.firstFrame = fframe;
sVideo.lastFrame  = lframe;
cParams.addParam('firstFrame',sVideo.firstFrame);%TODO check if already set
cParams.addParam('lastFrame',sVideo.lastFrame);

%% algorithm parameters
% 'G','PVG','XX'
cParams = insertIfNotExistent(cParams,'ppgExtractionMethod','G');
% 'dlib' 'drmf'
cParams = insertIfNotExistent(cParams,'faceTrackingMethod','dlib');
cParams = insertIfNotExistent(cParams,'useDetrending',1);
%normalizing parameters
meanNormalizationWinLengthInSec     = 0.8*3; % should be at least a pulse period
meanNormalizationWinLengthInFrames = roundNextOdd(sVideo.fps*meanNormalizationWinLengthInSec); 
cParams = insertIfNotExistent(cParams,'meanNormalizationWinLengthInFrames',meanNormalizationWinLengthInFrames);
%motion elimination parameters
cParams = insertIfNotExistent(cParams,'useMotionElemination',1);
motionWinlengthInFrames = floor(sVideo.fps/2); % window has to be odd
if mod(motionWinlengthInFrames,2) == 0
    motionWinlengthInFrames = motionWinlengthInFrames +1;
end
motionWindowShift = floor(motionWinlengthInFrames/2);
%warning('why not framerate dependent?');
cParams = insertIfNotExistent(cParams,'motionWinlengthInFrames',motionWinlengthInFrames);
cParams = insertIfNotExistent(cParams,'motionWindowShift',motionWindowShift);


%detrending method parameters
cParams = insertIfNotExistent(cParams,'lambda1', 55);
cParams = insertIfNotExistent(cParams,'lambda2', 56);

%threshold percentage
cParams = insertIfNotExistent(cParams,'percentage', 0.96);
cParams = insertIfNotExistent(cParams,'threshold',0.001973102363443);

%PSD estimation parameters
psdWinLengthInSec     = 5;
psdWinLengthInFrames = round(sVideo.fps*psdWinLengthInSec);
%warning('psd win was always longer than videos? -> todo');
cParams = insertIfNotExistent(cParams,'psdWinLengthInSec', psdWinLengthInSec);
cParams = insertIfNotExistent(cParams,'psdWinLengthInFrames', psdWinLengthInFrames);
cParams = insertIfNotExistent(cParams,'psdWinShift', floor(sVideo.fps));

%additional parameters
extraFramesNeeded = ceil(meanNormalizationWinLengthInFrames/2);
cParams = insertIfNotExistent(cParams,'videoAdditionalBorderFrames', extraFramesNeeded);
cParams = insertIfNotExistent(cParams,'multiply_factor_for_rectify', 1.1);

%sVideo
%extract first frame
sVideo.firstframe = videoGetFrame(sVideo.path,sVideo.firstFrame); 

%% set some paths
[~,sVideo.name,~] = fileparts(sVideo.path);

%make some dirs
path = sprintf('%s/data/%s',cd,sVideo.name);
mkdir(path);
path = sprintf('%s/data/%s/Figures',cd,sVideo.name);
mkdir(path);


%% path to output
sVideo.pathToOutput_video = sprintf('%s/data/%s/%s.avi',cd,sVideo.name);
sVideo.pathToOutput_figure = sprintf('%s/data/%s/Figures',cd,sVideo.name);
sVideo.pathToOutput_plot = sprintf('%s/data/%s',cd,sVideo.name);


switch cParams.getParam('faceTrackingMethod')
  case 'drmf'
    sVideo.pathToColorTraces = sprintf('%s/data/%s/colortraces_DRMF1.mat',cd,sVideo.name);  %colortraces' path
    sVideo.pathToLandmarks = sprintf(cd,'%s/data/%s/landmarks_DRMF1.mat',cd,sVideo.name);    %landmarks'path
  case 'dlib'    
    sVideo.pathToColorTraces = sprintf('%s/data/%s/colortraces_DLIB1.mat',cd,sVideo.name);  %colortraces' path
    sVideo.pathToLandmarks = sprintf('%s/data/%s/landmarks_DLIB1.mat',cd,sVideo.name);    %landmarks'path
  otherwise
    error('unknown landmarking/facetracking method');
end
    


end

function cParams = insertIfNotExistent(cParams,param,value)
if(cParams.exists(param) == 0)
  cParams.addParam(param,value);
end
end
