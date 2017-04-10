clc;
clear;
global i

%% add subfolder
addpath('subfolder');

%% set options and parameters
options = C_params('method Parameter');    %set name
options.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

%signal video or a whole database
fprintf('Which kind of input?\n');
flag_inputtype=input('Press: Single video[1]/Complete database[2]:\n');
fprintf('\n');
options.addParam('inputtype', flag_inputtype);

%set parameters manually or not
fprintf('Do you want to use defalut parameters or set them mannually\n?');
flag_setparameters=input('Press: defalut parameters[1]/set parameters mannually[2]:\n');
fprintf('\n');
options.addParam('setparameters',flag_setparameters);
if flag_setparameters==2
    CParams=set_parameters;
end

%calculte the groundtruth or import directly
fprintf('Do you want to calculate the groundtruth\n?');
flag_calgt=input('Press: calculate the groundtruth[1] or import the groundtruth[2]\n');
fprintf('\n');
options.addParam('calgt',flag_calgt);
if flag_calgt == 2        %import directly
    path_groundtruth = input('please input the path of groundtruth:\n');
    savepath = sprintf(path_groundtruth);
    load(savepath);                   %the value of groundtruth
elseif flag_calgt == 1    %calculate the groundtruth
    global pathtoECG
    pathtoECG = input('please input the path to ECG\n','s');
end
    


%calculte the colortraces or import directly
fprintf('Do you want to calculate the color traces and landmarks\n?');
flag_calcolortraces =input('Press: calculate the color traces and landmarks[1] or import the color traces and landmarks[2]\n');
fprintf('\n');
options.addParam('calcolortraces',flag_calcolortraces);
if flag_calcolortraces == 2
    path_colortraces = input('please input the path of colortraces:\n');
    savepath_colortraces = sprintf(path_colortraces);
    load(savepath_colortraces);      %the path to colortraces
    
    path_landmarks = input('please input the path of landmarks:\n');
    savepath_landmarks = sprintf(path_landmarks);
    load(savepath_landmarks);        %the üpath to landmarks
end

%% if it is a single video

flag1 = options.getParam('inputtype');
flag2 = options.getParam('setparameters');

if flag1==1
    %% step1: set sVideo
    i =1;
    flag_path = input('please input the path to the video:\n','s');
    sVideo.path = sprintf('%s',flag_path);    %video's path
    sVideo.pathToColorTraces = sprintf('');    %video's color traces, added in function EstimateHR
    sVideo.pathToLandmarks = sprintf('');      %video's landmarks, added in function EstimateHR 
    videoFileReader = vision.VideoFileReader(sVideo.path);

    S = info(videoFileReader);

    sVideo.fps = S.VideoFrameRate;
    sVideo.firstframe = step(videoFileReader);
    
    %these three parameters will probably be changed in the function EstimateHR

   
    %% step2: calculte results
    if flag2==1
        [sResults] = EstimateHR(sVideo, options);
    elseif flag2==2
        %% set options for algorithm
        flag_ppgrecover = input('which PPG signal recover method: G[1],PVG[2],XX[3]:\n');
        options.addParam('ppgrecover', flag_ppgrecover);

        flag_facefeaturemethod = input('which face feature method: DRMF[1],DILB[2]:\n');
        options.addParam('facefeaturemethod', flag_facefeaturemethod);
        
        inframe = input('please input the inframe\n');
        sVideo.inFrame = inframe;
        outframe = input('please input the outframe\n');
        sVideo.outFrame = outframe;
        sVideo.duaration = (sVideo.outFrame - sVideo.inFrame)/sVideo.fps;
        
        [sResults] = EstimateHR(sVideo, options, CParams);
    end
        
    %% step3: figure
    output_videoprocessed(sResults,options); %options to help judge the number of videos

    %% step4: measurements
    measurements = evaluate_HR_Estimation(sResults,options);    
    fprintf('Me(SDe): %4.2f(%4.2f), RMSE: %4.2f, Me_Rate: %4.2f%%, max_error: %4.2f, r: %4.2f, p: %4.2f\n',measurements.Me,measurements.SDe,measurements.RMSE,measurements.Me_Rate,measurements.max_error, measurements.r,measurements.p);
    
elseif flag1 == 2
    

    %% use HCI database as example
    %% setup database parameter etc

    %use HCI database or add new databases
    fprintf('use HCI database or add new databases\n?');
    flag_database =input('Press: use HCI database[1] or add new database[2]\n');
    fprintf('\n');
    options.addParam('database',flag_database);

    database = add_database(options);

    %% step1: set sVideo
    for n=1:database.num_video

    sVideo{n}.path  = database{n}.path
    sVideo{n}.pathToColorTraces = sprintf('');
    sVideo{n}.pathToLandmarks = sprintf('');
    videoFileReader = vision.VideoFileReader(sVideo{n}.path);
    
    S = info(videoFileReader);
    
    sVideo{n}.fps = S.VideoFrameRate;
    sVideo{n}.firstframe = step(videoFileReader);
    
    sVideo{n}.inFrame = 306;
    sVideo{n}.outFrame = 2135;
    sVideo{n}.duaration = (sVideo{n}.outFrame - sVideo{n}.inFrame)/sVideo{n}.fps;   %these three parameters will probably be changed in the function EstimateHR

    end
    
    %% step2: calculate results
    
    
    if flag2 == 1
        for i=1:database.num_video
            [sResults{i}] = EstimateHR(sVideo{i}, options);
        end
        
    elseif flag2==2
        %% set options for algorithm
        flag_ppgrecover = input('which PPG signal recover method: G[1],PVG[2],XX[3]:\n');
        options.addParam('ppgrecover', flag_ppgrecover);

        flag_facefeaturemethod = input('which face feature method: DRMF[1],DILB[2]:\n');
        options.addParam('ppgrecover', flag_facefeaturemethod);
        
        inframe = input('please input the inframe\n');
        sVideo.inFrame = inframe;
        outframe = input('please input the outframe\n');
        sVideo.outFrame = outframe;
        sVideo.duaration = (sVideo.outFrame - sVideo.inFrame)/sVideo.fps;
        
        for i=1:database.num_video
            [sResults{i}] = EstimateHR(sVideo{i}, options, CParams);
        end
    end
        
    
    %% step3: figure
    output_videoprocessed(sResults,options);
    
    %% step4: measurements
    measurements = evaluate_HR_Estimation(sResults,options);    
    fprintf('Me(SDe): %4.2f(%4.2f), RMSE: %4.2f, Me_Rate: %4.2f%%, max_error: %4.2f, r: %4.2f, p: %4.2f\n',measurements.Me,measurements.SDe,measurements.RMSE,measurements.Me_Rate,measurements.max_error, measurements.r,measurements.p);
end
    %for i=1:database.num_video
  
    %sVideo = cellArrayAllVideoStructs{i};
  
    %[averageHR(i), sResults] = EstimateHR(sVideo,options);
  
    %% store the location of the temporal matfiles (landmarks, etc)
  
    %sVideo.pathToColorTraces= sResults...
    %sVideo.pathToLandmarks  = sResults...
  
    %cellArrayAllVideoStructs{i} = sVideo;
  
    %end

    %% store the cellArray so we can reuse the saved files


    %% calculate the results

    % could be a nice function

    