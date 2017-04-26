function [S_normalization, lastframe] = motion_elimination(signal,CParams,sVideo)

S=signal;
motionWinlengthInFrames = CParams.getParam('motionWinlengthInFrames');
motionWindowShift = CParams.getParam('motionWindowShift');
window_length = motionWinlengthInFrames;

window=hann(window_length);
shift=motionWindowShift;
half=floor(window_length/2);

%% segment the signal, calculate the SD and threshold
m=1;
for n=sVideo.firstFrame:shift:sVideo.lastFrame
  try  
    temp=S(n-half:n+half).*window';
  catch
    disp('TODO, fix windowing');
    m = m+1;
    continue;
  end
    SD(1,m)=std(temp,1);
    m=m+1;
end

plot(signal);
saveas(gcf,[sVideo.pathToOutput_plot,'/','signal.jpg']);
close(gcf);

subplot(2,1,1);
plot(signal);
subplot(2,1,2);
plot(SD);
saveas(gcf,[sVideo.pathToOutput_plot,'/','SD_plot.jpg']);
close(gcf);

percentage = CParams.getParam('percentage');
%warning('percentage parameter is not used!');
threshold = max(SD)*percentage;
%threshold = CParams.getParam('threshold');
[~,pos]=find(SD>threshold);
N=length(pos);

%index=ones(1,length(S));
%for k=1:N
  % todo too much hardcoding here
    %index(round((pos(k)-1)*shift-half+5*sVideo.fps+1:(pos(k)-1)*shift+half+5*sVideo.fps+1))=0;
%end
%index_flip=1-index;
%count=sum(index_flip);
%index=findflip(index);

if N==0 
    S=signal;
    lastframe=sVideo.lastFrame;
    S_normalization = S;
    return;
end

%if index==0 
    %S=signal;
    %lastframe=sVideo.lastFrame;
    %S_normalization = S;
    %return;
%end

%S=signal(1:index(1));
S = signal(sVideo.firstFrame:pos(1)*window_length-half);
for k = 1:N
    tmp = k+1;
    if tmp > N
        temp = signal(pos(k)*window_length+half:length(signal));
    else
        n1 = pos(k)*window_length+half;
        n2 = pos(k+1)*window_length-half;
        temp = signal(n1:n2);
    end
    S = [S,temp];
end
%for k=1:2:length(index)
    %offset = signal(index(k))-signal(index(k+1));
    %if k==length(index)-1
        %temp = signal(index(k+1)+1:end)+offset;
    %else
        %temp = signal(index(k+1)+1:index(k+2))+offset;
    %end
    %S=[S,temp];
%end

lastframe=length(S);
S_normalization = S;

subplot(3,1,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:N
    plot([pos(k)*window_length-half-sVideo.firstFrame,pos(k)*window_length-half-sVideo.firstFrame],[-0.01,0.01],'r:');
    plot([pos(k)*window_length+half-sVideo.firstFrame,pos(k)*window_length+half-sVideo.firstFrame],[-0.01,0.01],'r:');
    hold on;
    fill([pos(k)*window_length-half-sVideo.firstFrame,pos(k)*window_length+half-sVideo.firstFrame,pos(k)*window_length+half-sVideo.firstFrame,pos(k)*window_length-half-sVideo.firstFrame],[-0.01,-0.01,0.01,0.01],'red');
end
hold on;
plot(signal(sVideo.firstFrame:sVideo.firstFrame+lastframe));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,2);
plot(S);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,3);
bar(SD);
hold on;
plot([0,20],[threshold,threshold],'r:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(gcf,[sVideo.pathToOutput_plot,'/','motionelimination_plot.jpg']);
close(gcf);
end


