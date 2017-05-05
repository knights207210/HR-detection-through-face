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
    for j =4:length(sResult.result_for_plot)
        
        path = sprintf('%s/data/%s/Figures/%d',cd,sResult.sVideo.name,j);
        mkdir(path);
        count = sResult.sVideo.firstFrame;
        for n = sResult.sVideo.firstFrame:sResult.sVideo.lastFrame
            %%%% output plot
                %% HR results
            subplot(4,1,4,'position',[0.05,0.05,0.9,0.1]);
            
                sum = 0;
                max_height=max(sResult.result_for_plot{j}.HR);
                min_height = min(sResult.result_for_plot{j}.HR);
                for k =1:length(sResult.result_for_plot{j}.HR)
                    plot([sum,sum+psdWinLengthInFrames-1],[sResult.result_for_plot{j}.HR(k),sResult.result_for_plot{j}.HR(k)]);
                    xlim([0,length(sResult.result_for_plot{j}.normalizedsignal)]);
                    text(sum,sResult.result_for_plot{j}.HR(k)+0.01,num2str(sResult.result_for_plot{j}.HR(k)*60),'fontsize',5);
                    sum = sum+psdWinShift;
                    hold on;
                    ylim([min_height*0.9,max_height*1.1]);
                end
                hold on;
                plot([count,count],[min_height*0.9,max_height*1.1],'r');  
                
            %end
            title('HR Estimation');
        
                
        %% sub region and correct mean_value   
            subplot(4,1,3,'position',[0.05,0.2,0.9,0.1]);
            title('Subregion and Rectified Value');
            max_height = 0;
            for i = 2:length(sResult.result_for_plot)
                max_height_tmp = max(sResult.result_for_plot{i}.normalizedsignal);
                if max_height_tmp>max_height
                    max_height = max_height_tmp;
                end
            end
            min_height = 0;
            for i = 2:length(sResult.result_for_plot)
                min_height_tmp = min(sResult.result_for_plot{i}.normalizedsignal);
                if min_height_tmp<min_height
                    min_height = min_height_tmp;
                end
            end
            for i = 2:length(sResult.result_for_plot)
                hold on;
                plot(sResult.result_for_plot{i}.normalizedsignal(sResult.sVideo.firstFrame:sResult.sVideo.lastFrame));    
                legend1 = legend('sub1','sub2','rectified value');
                set(legend1,'Position',[0.85797683105482 0.251534726217737 0.0826359844864228 0.0423976618981411],'FontSize',5);
                ylim([min_height,max_height]);
                xlim([0,length(sResult.result_for_plot{1}.normalizedsignal)]);
           end
            
            
            for i = 2:length(sResult.result_for_plot)
                hold on;
               
                for k=1:length(sResult.result_for_plot{i}.pos)
                    pos = sResult.result_for_plot{i}.pos;
                    plot([pos(k)*shift-shift,pos(k)*shift-shift],[min_height,max_height]);
                    hold on;
                    plot([pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift],[min_height,max_height]);
                    hold on;
                    patch([pos(k)*shift-shift,pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift,pos(k)*shift-shift],[min_height,min_height,max_height,max_height],'green','facealpha',0.3);
                    ylim([min_height,max_height]);
                    xlim([0,length(sResult.result_for_plot{1}.normalizedsignal)]);
                end
                
             
            
                hold on;
                plot([count,count],[min_height,max_height],'r');      
            end
           
             
        %% mean_value
            subplot(4,1,2,'position',[0.05,0.35,0.9,0.1]);
            
                max_height = max(sResult.result_for_plot{j}.normalizedsignal);
                min_height = min(sResult.result_for_plot{j}.normalizedsignal);
                for k=1:length(sResult.result_for_plot{j}.pos)
                    pos = sResult.result_for_plot{j}.pos;
                    plot([pos(k)*shift-shift,pos(k)*shift-shift],[min_height,max_height],'g:');
                    hold on;
                    plot([pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift],[min_height,max_height],'g:');
                    hold on;
                    fill([pos(k)*shift-shift,pos(k)*shift+window_length-shift,pos(k)*shift+window_length-shift,pos(k)*shift-shift],[min_height,min_height,max_height,max_height],'green');
                    ylim([min_height,max_height]);
                    xlim([0,length(sResult.result_for_plot{j}.normalizedsignal)]);
                end
                
                hold on;
                plot(sResult.result_for_plot{j}.normalizedsignal(sResult.sVideo.firstFrame:sResult.sVideo.lastFrame));
                
                hold on;
                plot([count,count],[min_height,max_height],'r');    
                title('Mean Value');

        
        %% video
            frame = step(VideoFileReader);
            count = output_videoprocessed(frame,facial_landmarks{n},j-1,n,sResult,count);
            
        end
        %% output video
        picFormat = 'jpg';
        syscall = ['ffmpeg -f image2 -i ' cd,'/data/',sResult.sVideo.name,'/Figures/',num2str(j),'/%d.',picFormat,' -r ',num2str(round(sResult.sVideo.fps)),' ','-q 0 ',sResult.sVideo.name,'_',num2str(j),'.avi'];
        [status,cmdout] = system(syscall,'-echo');
    end
    

end
end

