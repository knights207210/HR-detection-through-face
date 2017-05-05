function index = findflip(signal)
index=0;

n=1;
for k=1:length(signal)-1
    if signal(k)~=signal(k+1)
        index(n)=k;
        n=n+1;
    end
end

end

