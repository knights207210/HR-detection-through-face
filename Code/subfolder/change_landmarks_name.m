n=508;

for folder=2:2:40
        path = sprintf('/home/hanxu/thesis/mycode/P30-Rec1-2009.09.03.14.25.18_C1 trigger _C_Section_%d.mkv_FRAMERATEDIFF.mat',folder);
        facial_landmarks = load(path,'facial_landmarks');
        savepath = sprintf('/home/hanxu/thesis/NewFolder/data/HCIdata/landmarks/landmarks%d.mat',n);
        save(savepath,'facial_landmarks');
        n = n+1;

end
        