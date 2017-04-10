function [S_normalization, lastframe] = motion_elimination(signal,CParams,sVideo)

S=signal;
motionWinlengthInFrames = CParams.getParam('motionWinlengthInFrames');
motionWindowShift = CParams.getParam('motionWindowShift');
window_length = motionWinlengthInFrames;

window=hann(window_length);
shift=motionWindowShift;
half=floor(window_length);

%% segment the signal, calculate the SD and threshold
m=1;
for n=sVideo.firstFrame:shift:sVideo.lastFrame
    temp=S(n-half:n+half).*window';
    SD(1,m)=std(temp,1);
    m=m+1;
end
CParams.threshold = max(SD)*CParams.percentage;
[~,pos]=find(SD>CParams.threshold);
N=length(pos);

index=ones(1,length(Signal));
for k=1:N
    index((pos(k)-1)*shift-half+5*video.fps+1:(pos(k)-1)*shift+half+5*video.fps+1)=0;
end
index_flip=1-index;
count=sum(index_flip);
index=findflip(index);

if index==0
    S=Signal;
    lastframe=sVideo.lastFrame;
    return;
end
S=Signal(1:index(1));

for k=1:2:length(index)
    offset = Signal(index(k))-Signal(index(k+1));
    if k==length(index)-1
        temp = Signal(index(k+1)+1:end)+offset;
    else
        temp = Signal(index(k+1)+1:index(k+2))+offset;
    end
    S=[S,temp];
end

lastframe=video.lastFrame-count;
S_normalization = S;

end


