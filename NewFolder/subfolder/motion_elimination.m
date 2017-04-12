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
    temp=S(n-half:n+half).*window';
    SD(1,m)=std(temp,1);
    m=m+1;
end

subplot(2,1,1);
plot(signal);
subplot(2,1,2);
plot(SD);
saveas(gcf,[sVideo.pathtooutput_plot,'/','plot.jpg']);
%close(gcf);

percentage = CParams.getParam('percentage');
%threshold = max(SD)*percentage;
threshold = CParams.getParam('threshold');
[~,pos]=find(SD>threshold);
N=length(pos);

index=ones(1,length(S));
for k=1:N
    
    index(round((pos(k)-1)*shift-half+5*sVideo.fps+1:(pos(k)-1)*shift+half+5*sVideo.fps+1))=0;
end
index_flip=1-index;
count=sum(index_flip);
index=findflip(index);

if index==0 
    S=signal;
    lastframe=sVideo.lastFrame;
    S_normalization = S;
    return;
end
S=signal(1:index(1));

for k=1:2:length(index)
    offset = signal(index(k))-signal(index(k+1));
    if k==length(index)-1
        temp = signal(index(k+1)+1:end)+offset;
    else
        temp = signal(index(k+1)+1:index(k+2))+offset;
    end
    S=[S,temp];
end

lastframe=sVideo.lastFrame-count;
S_normalization = S;

end


