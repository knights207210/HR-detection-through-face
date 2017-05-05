function [ Y ] = bandpass(X,cut_low,cut_high,fps,method,n)
%
%
if strcmp(method,'FIR')
    Wn = [cut_low/(fps/2),cut_high/(fps/2)];
    h = fir1(n,Wn);
    Y = filtfilt(h,1,X);
    %Y = filter(h,1,X);
%     [n,wn,bta,ftype] = kaiserord([0.6/(fps/2)*pi cut_low/(fps/2)*pi cut_high/(fps/2)*pi 4.1/(fps/2)*pi],[0 1 0],[0.01 0.1087 0.01]);
%     h = fir1(n,wn,ftype,kaiser(n+1,bta),'noscale');
%     Y = filter(h,1,X);
else
    [b,a] = butter(6,[cut_low/(fps/2) cut_high/(fps/2)],'bandpass');
    Y = filter(b,a,X);
%end

end

