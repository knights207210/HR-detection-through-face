function [ temp, PeakHeight, low_cutoff, high_cutoff  ] = adjust_parameters(temp, ECG, PeakHeight, low_cutoff, high_cutoff )

fprintf('which parameter you want to change?\n');
flag=input('Press: PeakHeight[1], low_cutoff[2], high_cutoff[3] \n');
switch flag
    case 1
        PeakHeight=input('Input PeakHeight\n');
    case 2
        low_cutoff=input('Input low cut-off frequency\n');
        [ temp ] = refine_ECG( ECG , low_cutoff, high_cutoff);
    case 3
        high_cutoff=input('Input high cut-off frequency\n');  
        [ temp ] = refine_ECG( ECG , low_cutoff, high_cutoff);
end
findpeaks(temp,'MinPeakDistance',100,'MinPeakHeight',PeakHeight);

fprintf('Still need to change?\n');
flag=input('Press: Yes[1]/No[2] \n');
if flag==1
    [ temp,PeakHeight, low_cutoff, high_cutoff  ] = adjust_parameters(temp, ECG, PeakHeight, low_cutoff, high_cutoff );
else
    return;
end
end

