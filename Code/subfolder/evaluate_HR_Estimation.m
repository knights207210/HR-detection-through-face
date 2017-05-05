function [ measurements ] = evaluate_HR_Estimation( sResults, options )
%evaluate_HR_Estimation Summary of this function goes here
%need to consider the single video or databases
flag = options.getParam('inputtype');
if flag == 1     % single video
    measurements.N = length(sResults.averageHR);
    measurements.HR_error = sResults.averageHR-sResults.averageHR_GT;
    measurements.Me = sum(measurements.HR_error)/measurements.N;
    measurements.SDe = std(measurements.HR_error,1,2);
    measurements.RMSE = sqrt(measurements.HR_error*measurements.HR_error'/measurements.N);
    measurements.Me_Rate = sum(abs(measurements.HR_error)./sResults.averageHR_GT)/measurements.N*100;
    %[r,p] = corrcoef(sResults.averageHR,sResults.averageHR_GT);
    %measurements.r = r(2);
    %measurements.p = p(2);
    
elseif flag == 2     %database
    for k =1:length(sResults)
        HR(k) = sResults{k}.averageHR;
        HR_GT(k) = sResults{k}.averageHR_GT;
    end
    
    measurements.N = length(HR);
    measurements.HR_error = HR-HR_GT;
    measurements.Me = sum(measurements.HR_error)/measurements.N;
    measurements.SDe = std(measurements.HR_error,1,2);
    measurements.RMSE = sqrt(measurements.HR_error*measurements.HR_error'/measurements.N);
    measurements.Me_Rate = sum(abs(measurements.HR_error)./HR_GT)/measurements.N*100;
    [r,p] = corrcoef(HR,HR_GT);
    measurements.r = r(2);
    measurements.p = p(2)
end
     


end

