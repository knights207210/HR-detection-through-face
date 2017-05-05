n=1;
for subject=1:30
        if subject==12||subject==15||subject==26
            continue;
        end
for trail=1:20
        folder = 2*trail+130*(subject-1);
        if (folder>=296&&folder<=300)||(folder>=1070&&folder<=1080)||(folder>=1984&&folder<=1990)%||folder==674
            continue;
        end
        fprintf('subject %d, trail %d\n',subject, trail);
        path = sprintf('/home/hanxu/thesis/NewFolder/data/HCIdata/subject%d_trail%d.mat',subject,trail);
        mean_value = load(path,'mean_value');
        transformation_matrix = load(path, 'transformation_matrix_f');
        savepath = sprintf('colortraces%d.mat',n);
        save(savepath,'mean_value','transformation_matrix');
        n = n+1;
end
end
        