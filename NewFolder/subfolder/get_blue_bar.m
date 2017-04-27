function [sum] = get_blue_bar(sResult)
%this function is aimed to extract the blue bar from video, which indiciate
%the trend of the heart rate

flag = sResult.cParams.getParam('outputbluebar');

%%output video or not
if flag == 0
    return;
else

% for the first frame, need to get roi mannually
videoFileReader = vision.VideoFileReader(sResult.sVideo.path);
for k =1:sResult.sVideo.firstFrame-1
    [~] = step(videoFileReader);
end
frame = step(videoFileReader);
[bluebar_region{1}, column, row] = roipoly(frame);

%%save figure
[H,W,~]=size(frame);
maxwidth = round(max(column));
minwidth = round(min(column));
maxheight = round(max(row));
minheight = round(min(row));
if maxheight>H
  maxheight = H;
end

im_X = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
im_Y = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
for h=1:maxheight-minheight+1
  im_X(h,:) = minheight+h-1;
  im_Y(h,:) = minwidth:maxwidth;
end

in = inpolygon(im_X,im_Y,[row;row(1)],[column;column(1)]);
mask_image = zeros(H,W);
mask_image(minheight:maxheight,minwidth:maxwidth) = in;
output{1}(:,:,1) = mask_image.*frame(:,:,1);
output{1}(:,:,2) = mask_image.*frame(:,:,2);
output{1}(:,:,3) = mask_image.*frame(:,:,3);
imshow(output{1}(minheight:maxheight,minwidth:maxwidth,:));
path = sprintf('%s/data/%s/bluebar',cd,sResult.sVideo.name);
mkdir(path);
savepath = sprintf('%s/data/%s/bluebar/%d.jpg',cd,sResult.sVideo.name,0);
saveas(gcf,[savepath]);

sum = zeros(1,sResult.sVideo.lastFrame);
for i = minheight:maxheight
    for j = minwidth:maxwidth
      RGB_value(i,j) = output{1}(i,j,1)+output{1}(i,j,2)+output{1}(i,j,3);
      sum(1) = RGB_value(i,j)+sum(1);
    end
end


for m = 2:sResult.sVideo.lastFrame
    frame = step(videoFileReader);
    output{m}(:,:,1) = mask_image.*frame(:,:,1);
    output{m}(:,:,2) = mask_image.*frame(:,:,2);
    output{m}(:,:,3) = mask_image.*frame(:,:,3);
    imshow(output{m}(minheight:maxheight,minwidth:maxwidth,:));
    savepath = sprintf('%s/data/%s/bluebar/%d.jpg',cd,sResult.sVideo.name,m-1);
    saveas(gcf,[savepath]);
for i = minheight:maxheight
    for j = minwidth:maxwidth
      RGB_value(i,j) = output{m}(i,j,1)+output{m}(i,j,2)+output{m}(i,j,3);
      sum(m) = RGB_value(i,j)+sum(m);
    end
end
end
bar(sum);
end    


end

