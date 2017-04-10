function [ facial_landmarks ] = DRMF_facial_landmarks( video )
%

addpath(genpath('.'));
    
% ------------------------------------------------%
% % % 
% % % Choose Face Detector
% % % 0: Tree-Based Face Detector (p204);
% % % 1: Matlab Face Detector (or External Face Detector);
% % % 2: Use Pre-computed Bounding Boxes
% % % 
% % % NOTES:
% % % [a]   Option '0' is very accurate and suited for faces in the 'wild';
% % %       But it is EXTREMELY slow!!!
% % % [b]   Option '1' supports the functionality for incorporating
% % %       YOUR OWN FACE DETECTOR WITH DRMF FITTING;
% % %       Simply modify the function External_Face_Detector.m
% % % 

bbox_method =0;
%------------------------------------------------%


%------------------------------------------------%
% % % Choose Visualize
% % % 0: Do Not Display Fitting Results;
% % % 1: Display Fitting Results and Pause of Inspection)
% % % 

visualize=0;
%------------------------------------------------%


%------------------------------------------------%
% % % Load Test Images

data.name=video.path;
data.img=im2double(video.firstframe);
% % % Required Only for bbox_method = 2; 
data.bbox=[]; % Face Detection Bounding Box [x;y;w;h]
% % % Initialization to store the results
data.points=[]; % MAT containing 66 Landmark Locations
data.pose=[]; % POSE information [Pitch;Yaw;Roll]

%------------------------------------------------%


%------------------------------------------------%
%Run Demo

clm_model='DRMF_model/DRMF_Model.mat';
load(clm_model);    
facial_landmarks=DRMF(clm_model,data,bbox_method,visualize);    

%------------------------------------------------%
end

