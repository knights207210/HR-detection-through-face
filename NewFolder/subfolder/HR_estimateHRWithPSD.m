function [ HR ] = HR_estimateHRWithPSD(signal,sVideo,CParams)
% to extrate HR, we fist filter S and 
% select the 0.7-4 Hz frequency components.

psdWinLengthInFrames = CParams.getParam('psdWinLengthInFrames');
psdWinShift = CParams.getParam('psdWinShift');

S_bandpass = bandpass(signal,0.7,4,sVideo.fps,'FIR',round(sVideo.fps*3));
%HR_length = length(signal)-psdWinLengthInFrames+1;
     
% find the largest value in PSD
   %for n=1:psdWinShift:HR_length
   for n=1:psdWinShift:length(signal)
     try
     temp_S = S_bandpass(n:n+psdWinLengthInFrames-1);
     catch
     end
     temp_S = padarray(temp_S,length(temp_S));
     [pxx,f] = pwelch(temp_S,[],[],psdWinLengthInFrames,sVideo.fps);
     maxPSD_value_position = find(pxx==max(pxx));
     HR_frequency = f(maxPSD_value_position);
     HR(1,(n-1)/psdWinShift+1) = HR_frequency;
   end        

   %warning('commented out this line, because it was not working');
HR = HR(round(sVideo.firstFrame/sVideo.fps)+1:round(sVideo.lastFrame/sVideo.fps));
%TODO this seems wrong. if psdWinShift is fixed 60, working with fps 
% will fail!
end

