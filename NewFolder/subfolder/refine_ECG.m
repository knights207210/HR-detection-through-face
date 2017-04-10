function [ ECG_refine ] = refine_ECG( ECG , low_cutoff, high_cutoff)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
n= 1000;

Wn = [low_cutoff/(256/2),high_cutoff/(256/2)];
h = fir1(n,Wn);
ECG_bandpass = filter(h,1,ECG);
ECG_bandpass(find(ECG_bandpass<0)) = 0;
ECG_2 = ECG_bandpass.*ECG_bandpass;
ECG_refine = double(ECG_2(256*5+1:256*35));

end

