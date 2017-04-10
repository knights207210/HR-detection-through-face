function [ HR ] = HR_estimateHRWithPSD(signal,sVideo,CParams)
% to extrate HR, we fist filter S and 
% select the 0.7-4 Hz frequency components.

psdWinLengthInFrames = CParams.getParam('psdWinLengthInFrames');
psdWinShift = CParams.getParam('psdWinShift');

S_bandpass = bandpass(signal,0.7,4,video.fps,'FIR',1024);

HR_length = length(S)-psdWinLengthInFrames+1;
     
% find the largest value in PSD
   for n=1:psdWinShift:HR_length 
     temp_S = S_bandpass(n:n+psdWinLengthInFrames-1);    
     [pxx,f] = pwelch(temp_S,[],[],psdWinLengthInFrames,sVideo.fps);
     maxPSD_value_position = find(pxx==max(pxx));
     HR_frequency = f(maxPSD_value_position);
     HR(1,(n-1)/psdWinShift+1) = HR_frequency;
   end        


end

