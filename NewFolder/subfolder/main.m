%%main

%%add parameters to C_Param, including all the windowlengths and shiftlengths
add_parameters(C_Param);
video = set_parameters(C_Param);

%%load meanvalues calculated from color traces
mean_values = loadcolortraces(options);           %options.database (path)

%%normalizing
normalized_signal = normalizing (mean_values);

%%PPG singal processing
%%several methods including G
S_normalization = PPG_signalextraction(normalized_signal, options);  %options.PPGsignalmethod---which PPG signal extraction method to use
plot(S_normalization);

%%calculate the threshold and store the SD of each segment
[threshold,SD] = HR_calThreshold(S_normalization,C_Param);   
figurethreshold(threshold, SD);

%%motion elimination
[S_motioneliminated,video.lastFrame] = motion_elimination_window(S_normalization,threshold,video,CParams,SD);
figure_motioneliminated(S_motioneliminated, SD);    %compare before and after motion eliminated

%%detrending method
S_detrend = detrending(S_motioneliminated);

%%HR extraction
HR = HR_extraction(S_detrend);

%%compare with groundtruth
measurements(HR,HR_groundtruth);
figureresults(HR, HR_groundtruth);    %output the figure of the results




