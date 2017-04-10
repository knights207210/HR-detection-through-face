function [HR,afterMotionElimination] = PPG_processing(mean_value,sVideo,CParams,options)

%% Normalizing
normalized_signal = normalizing(mean_value,CParams);

%% PPG recovering
if options.ppgrecover == 1   %G method
    S_normalization_temp = normalized_signal(:,2)';

elseif options.ppgrecover == 2
elseif options.ppgrecover == 3

end

%% motion elimination
[S_normalization, lastframe] = motion_elimination(S_normalization_temp,Cparams,sVideo);
sVideo.lastfrmane = lastframe;
afterMotionElimination = S_normalization;

%% detrending method
if options.detrendmethod == 1
    T = length(S_normalization);
    I = speye(T);
    D2 = spdiags(ones(T-2,1)*[1 -2 1],[0:2],T-2,T);
    S_normalization2 = (I-inv(I+lambda1^2*(D2'*D2)))*S_normalization';
    S_normalization3 = (I-inv(I+lambda2^2*(D2'*D2)))*(S_normalization'-S_normalization2);
else
    S_normalization3 = S_normalization;
end

%% HR estimation window
    HR = HR_estimateHRWithPSD(S_normalization3,sVideo,CParams);
end

