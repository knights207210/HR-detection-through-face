function [] = output( sResult )

flag = sResult.cParams.getParam('outputvideo');
motionWinlengthInFrames = sResult.cParams.getParam('motionWinlengthInFrames');
motionWindowShift = sResult.cParams.getParam('motionWindowShift');
window_length = motionWinlengthInFrames;
shift=motionWindowShift;
psdWinShift = sResult.cParams.getParam('psdWinShift');
psdWinLengthInFrames = sResult.cParams.getParam('psdWinLengthInFrames');

if flag == 0
    return;
else
    path_video = sResult.sVideo.path;
    path_landmarks = sResult.sVideo.pathToLandmarks;
    load(path_landmarks);
    VideoFileReader = vision.VideoFileReader(path_video);
    for k =1:sResult.sVideo.firstFrame-1
            [~] = step(VideoFileReader);
    end
    
    %%mean_value's plot and video with mask
    %% output plot and video
    %%%% output video
    for j =1:length(sResult.result_for_plot)
        
        path = sprintf('%s/data/%s/Figures/%d',cd,sResult.sVideo.name,j);
        mkdir(path);
        
        for n = sResult.sVideo.firstFrame:sResult.sVideo.lastFrame
            %%%% output plot
                %% HR results
            subplot(4,1,4,'position',[0.05,0.05,0.9,0.1]);
            %for j =1:length(sResult.result_for_plot)
                sum = 0;
                max_height=max(sResult.result_for_plot{1}.HR);
                for k =1:length(sResult.result_for_plot{1}.HR)
                    plot([sum,sum+psdWinLengthInFrames-1],[sResult.result_for_plot{1}.HR(k),sResult.result_for_plot{j}.HR(k)]);
                    xlim([0,length(sResult.result_for_plot{1}.normalizedsignal)]);
                    text(sum,sResult.result_for_plot{1}.HR(k)+0.01,num2str(sResult.result_for_plot{1}.HR(k)*60),'fontsize',5);
                    sum = sum+psdWinShift;
                    hold on;
                    ylim([0,max_height*2]);
                end
                hold on;
                plot([n,n],[0,max_height*2],'r');  
                
            %end
        
        
                
        %% sub region and correct mean_value   
            subplot(4,1,3,'position',[0.05,0.25,0.9,0.1]);
            max_height = 0;
            for i = 2:length(sResult.result_for_plot)
                max_height_tmp = max(sResult.result_for_plot{i}.normalizedsignal);
                if max_height_tmp>max_height
                    max_height = max_height_tmp;
                end
            end
            
            for i = 2:length(sResult.result_for_plot)
                hold on;    
                for k=1:length(sResult.result_for_plot{i}.pos)
                    pos = sResult.result_for_plot{i}.pos;
                    plot([pos(k)*shift-shift,pos(k)*shift-shift],[-2*max_height,max_height*2],'g:');
                    hold on;
                    plot([pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift],[-2*max_height,max_height*2],'g:');
                    hold on;
                    fill([pos(k)*shift-shift,pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift,pos(k)*shift-shift],[-2*max_height,-2*max_height,max_height*2,max_height*2],'green');
                    ylim([-2*max_height,max_height*2]);
                end
                hold on;
                plot(sResult.result_for_plot{i}.normalizedsignal(sResult.sVideo.firstFrame:sResult.sVideo.lastFrame));
                hold on;
                plot([n,n],[-2*max_height,max_height*2],'r');      
            end
            
        %% mean_value
            subplot(4,1,2,'position',[0.05,0.45,0.9,0.1]);
                max_height = max(sResult.result_for_plot{1}.normalizedsignal);
                for k=1:length(sResult.result_for_plot{1}.pos)
                    pos = sResult.result_for_plot{1}.pos;
                    plot([pos(k)*shift-shift,pos(k)*shift-shift],[-2*max_height,max_height*2],'g:');
                    hold on;
                    plot([pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift],[-2*max_height,max_height*2],'g:');
                    hold on;
                    fill([pos(k)*shift-shift,pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift,pos(k)*shift-shift],[-2*max_height,-2*max_height,max_height*2,max_height*2],'green');
                    ylim([-2*max_height,max_height*2]);
                end
                
                hold on;
                plot(sResult.result_for_plot{1}.normalizedsignal(sResult.sVideo.firstFrame:sResult.sVideo.lastFrame));
                hold on;
                plot([n,n],[-2*max_height,max_height*2],'r');    
        

        
        %% video
            frame = step(VideoFileReader);
            output_videoprocessed(frame,facial_landmarks{n},j-1,n);
            savepath = sprintf('%s/data/%s/Figures/%d/%d.jpg',cd,sResult.sVideo.name,j,n-sResult.sVideo.firstFrame);
            saveas(gcf,[savepath]);
            close(gcf);
        end
        %% output video
        picFormat = 'jpg';
        syscall = ['ffmpeg -f image2 -i ' cd,'/data/',sResult.sVideo.name,'/Figures/',num2str(j),'%d.',picFormat,' -r ',num2str(round(sResult.sVideo.fps)),' ',sResultsVideo.name,'.avi'];
        [status,cmdout] = system(syscall,'-echo');
    end
    

end
end

