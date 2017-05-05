function [HR,result_for_plot] = PPG_processing(mean_value,sVideo,cParams)

%% Normalizing
normalized_signal = normalizing(mean_value,cParams);

%% PPG recovering
switch  cParams.getParam('ppgExtractionMethod')
  
  case 'G'
    S_normalization_temp = normalized_signal(:,2)';
  case 'PVG'
    error('not implmented');
  case 'XX'
    error('not implmented');
  otherwise
    error('not implmented');
    
end

%% motion elimination
if  cParams.getParam('useMotionElemination') == 1
[S_normalization,pos,SD,threshold] = motion_elimination(S_normalization_temp,cParams,sVideo);
else
S_normalization = S_normalization_temp;
end



%% detrending method
if cParams.getParam('useDetrending') == 1
    lambda1 = cParams.getParam('lambda1');
    lambda2 = cParams.getParam('lambda2');
    T = length(S_normalization);
    I = speye(T);
    D2 = spdiags(ones(T-2,1)*[1 -2 1],[0:2],T-2,T);
    S_normalization2 = (I-inv(I+lambda1^2*(D2'*D2)))*S_normalization';
    S_normalization3 = (I-inv(I+lambda2^2*(D2'*D2)))*(S_normalization'-S_normalization2);
else
    S_normalization3 = S_normalization;
end
    figure;
    subplot(3,1,1);
    plot(S_normalization);
    subplot(3,1,2);
    plot(S_normalization3);
    subplot(3,1,3);
    plot(S_normalization);
    hold on;
    plot(S_normalization3,'r');
    
%% HR estimation window
    [HR,S_bandpass] = HR_estimateHRWithPSD(S_normalization3,sVideo,cParams);
    
%% result for plot
    result_for_plot.normalizedsignal = S_normalization_temp;
    result_for_plot.pos = pos;
    result_for_plot.S_normalization = S_normalization;
    result_for_plot.threshold = threshold;
    result_for_plot.SD = SD;
    result_for_plot.S_normalization3 = S_normalization3;
    result_for_plot.S_bandpass = S_bandpass;
    result_for_plot.HR = HR;
end

