function [ HR, S_bandpass] = HR_estimateHRWithPSD(signal,sVideo,CParams)
% to extrate HR, we fist filter S and 
% select the 0.7-4 Hz frequency components.
psdWinLengthInFrames = CParams.getParam('psdWinLengthInFrames');
psdWinShift = CParams.getParam('psdWinShift');

S_bandpass = bandpass(signal,0.7,4,sVideo.fps,'FIR',round(sVideo.fps*2));
figure;
subplot(3,1,1);
plot(signal);
subplot(3,1,2);
plot(signal);
hold on;
plot(S_bandpass,'r');
% find the largest value in PSD
   for n=1:psdWinShift:length(signal)
     try
     temp_S = S_bandpass(n:n+psdWinLengthInFrames-1);
     catch
     end
     temp_S = padarray(temp_S,length(temp_S));
     [pxx,f] = pwelch(temp_S,[],[],psdWinLengthInFrames*2,sVideo.fps);
     maxPSD_value_position = find(pxx==max(pxx));
     HR_frequency = f(maxPSD_value_position);
     HR(1,(n-1)/psdWinShift+1) = HR_frequency;
   end        
subplot(3,1,3);
    sum = 0;
    for k =1:length(HR)
        plot([sum,sum+psdWinLengthInFrames-1],[HR(k),HR(k)]);
        sum = sum+psdWinShift;
        hold on;
    end
HR = HR(round(sVideo.firstFrame/sVideo.fps)+1:round(sVideo.lastFrame/sVideo.fps));
end

