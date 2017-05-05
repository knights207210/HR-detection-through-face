clc;
clear;
global i
%% add subfolder
addpath('subfolder');

%% set options 
options = set_options;

flag1 = options.getParam('inputtype');
flag2 = options.getParam('setparameters');


%% if it is a single video
if flag1==1
    i=1;
    %% step1: set sVideo,options & CParams
    [sVideo,options,CParams] = set_parameters(options);
    
    %% step2: calculte results
    if flag2==1
        [sResults] = EstimateHR(sVideo, options);
    elseif flag2==2
        [sResults] = EstimateHR(sVideo, options, CParams);
    end
        
    %% step3: figure
    flag_output = input('output the video[1] or not[2]');
    options.addParam('flag_output', flag_output);
    if flag_output == 1
    output_videoprocessed(sResults,options);
    end
   %options to help judge the number of videos

    %% step4: measurements
    measurements = evaluate_HR_Estimation(sResults,options);    
    fprintf('Me(SDe): %4.2f(%4.2f), RMSE: %4.2f, Me_Rate: %4.2f\n',measurements.Me,measurements.SDe,measurements.RMSE,measurements.Me_Rate);

%% if it is a dataset
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
        [sVideo{n},option{n},CParams{n}] = set_parameters(options,n);
    end
    
    %% step2: calculate results
    
    if flag2 == 1
        for i=1:database.num_video
            fprintf('%d\n',i);
            [sResults{i}] = EstimateHR(sVideo{i}, option{i});
        end
        
    elseif flag2==2
        
        for i=1:database.num_video
            fprintf('%d\n',i);
            [sResults{i}] = EstimateHR(sVideo{i}, option{i}, CParams{i});
        end
    end
        
    
    %% step3: figure
    flag_output = input('output the video[1] or not[2]');
    options.addParam('flag_output', flag_output);
    if flag_output == 1
    output_videoprocessed(sResults,options);
    end
    
    %% step4: measurements
    measurements = evaluate_HR_Estimation(sResults,options);    
    fprintf('Me(SDe): %4.2f(%4.2f), RMSE: %4.2f, Me_Rate: %4.2f, r: %4.2f, p: %4.2f\n',measurements.Me,measurements.SDe,measurements.RMSE,measurements.Me_Rate, measurements.r,measurements.p);
end

    