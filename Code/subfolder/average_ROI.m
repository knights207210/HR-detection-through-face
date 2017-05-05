function [ mean_value ] = average_ROI(videoFrame,ROI_boundary_points,show)
%
%
%flip to let the value of ROI_boundary_points in the same coordinate as the image 
ROI_boundary_points = round(fliplr(ROI_boundary_points));
videoFrame = double(videoFrame);
[H,W,~] = size(videoFrame);

% the following is trying to judge which pixel is inside ROI. 'inpolygon.m'
% makes the judgement. I first narrow the region to reduce computation. 
maxwidth = round(max(ROI_boundary_points(:,2)));
minwidth = round(min(ROI_boundary_points(:,2)));
maxheight = round(max(ROI_boundary_points(:,1)));
minheight = round(min(ROI_boundary_points(:,1)));
if maxheight>H
    maxheight = H;
end
im_X = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
im_Y = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
for h=1:maxheight-minheight+1
    im_X(h,:) = minheight+h-1;
    im_Y(h,:) = minwidth:maxwidth;
end
IN_face = inpolygon(im_X,im_Y,[ROI_boundary_points(:,1);ROI_boundary_points(1,1)],[ROI_boundary_points(:,2);ROI_boundary_points(1,2)]);
% create the mask for ROI 
mask_image = zeros(H,W);
mask_image(minheight:maxheight,minwidth:maxwidth) = IN_face;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test the result
if show==1
inverse_mask_image=~mask_image;
test_image(:,:,1)=inverse_mask_image.*videoFrame(:,:,1);
test_image(:,:,2)=inverse_mask_image.*videoFrame(:,:,2);
test_image(:,:,3)=inverse_mask_image.*videoFrame(:,:,3);
% test_image=uint8(test_image);
imshow(test_image);
end

% derive the mean values for RGB channels
pixel_number = sum(sum(mask_image)');
mean_value(1,1)=sum(sum(mask_image.*videoFrame(:,:,1))')/pixel_number;% mean value in R channel.
mean_value(1,2)=sum(sum(mask_image.*videoFrame(:,:,2))')/pixel_number;% mean value in G channel.
mean_value(1,3)=sum(sum(mask_image.*videoFrame(:,:,3))')/pixel_number;% mean value in B channel.
end

