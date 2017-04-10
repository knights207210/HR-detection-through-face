function [ groundtruth ] = cal_gt(pathtoECG,i)
%cal_gt Summary of this function goes here
%   this function is used to calculate the groundtruth of a single video

low_cutoff=1;
high_cutoff=5;
PeakHeight=4*10^6;
ecg_save_path = sprintf('%s/%d.mat',pathtoECG,i);
load(ecg_save_path);
ECG = detrend(ECG);
temp = refine_ECG( ECG , low_cutoff, high_cutoff);

findpeaks(temp,'MinPeakDistance',100,'MinPeakHeight',PeakHeight);
fprintf('Are the deteced peaks right?\n ');
flag=input('Press: Yes[1]/No[2]: \n ');
fprintf('\n ');
if flag==2

    [ temp, PeakHeight, low_cutoff, high_cutoff  ] = adjust_parameters(temp, ECG, PeakHeight, low_cutoff, high_cutoff );
    
end
[~,pos]=findpeaks(temp,'MinPeakDistance',100,'MinPeakHeight',PeakHeight);


time_place = (pos(2:end)-pos(1:end-1))/256;
time_place = 60./time_place;
groundtruth=time_place;

end

