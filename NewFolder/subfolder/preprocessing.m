%%add database
add_database;   %if there is a need to add databases    

%%calculate the groundtruth
HR_groundtruth = cal_groundtruth(options);      %options.database

%%extract color traces
[path.video, path.landmark] = extractcolortraces(options);   %options.database---which databases to choose   options.featurepointsmethod---which feature tracking methods to use

%%output video
output_video(options, path);