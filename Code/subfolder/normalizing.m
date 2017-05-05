function [ normalized_signal ] = normalizing(raw_signal,CParams )

%% decide win length
meanNormalizationWinLengthInFrames = CParams.getParam('meanNormalizationWinLengthInFrames');

signal_length = length(raw_signal(:,1));
normalized_signal = ones(signal_length,3);
window_length = round(meanNormalizationWinLengthInFrames);
if(mod(window_length,2) == 0)
    error('window has to be odd');
end
window_center = floor(window_length/2);
frame_start = window_center+1;
frame_end = signal_length-window_center-1;
for n=frame_start:frame_end
    normalized_signal(n,1) = raw_signal(n,1)/mean(raw_signal(n-window_center:n+window_center,1));
    normalized_signal(n,2) = raw_signal(n,2)/mean(raw_signal(n-window_center:n+window_center,2));
    normalized_signal(n,3) = raw_signal(n,3)/mean(raw_signal(n-window_center:n+window_center,3));
end

normalized_signal=normalized_signal-1;

end

