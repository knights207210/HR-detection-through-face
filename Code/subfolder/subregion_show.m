function [ test_image ] = subregion_show( videoFrame,ROI_boundary_points,side )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if side == 0
%%left side
ROI_boundary_points_left = [ROI_boundary_points(1,1),ROI_boundary_points(1,2);...
                     ROI_boundary_points(2,1),ROI_boundary_points(2,2);...
                     ROI_boundary_points(3,1),ROI_boundary_points(3,2);...
                     ROI_boundary_points(4,1),ROI_boundary_points(4,2);...
                     ROI_boundary_points(10,1),ROI_boundary_points(10,2)];
%%flip
ROI_boundary_points_left = round(fliplr(ROI_boundary_points_left));
videoFrame = double(videoFrame);
[H,W,~] = size(videoFrame);

%%narrow reigon
maxwidth = round(max(ROI_boundary_points_left(:,2)));
minwidth = round(min(ROI_boundary_points_left(:,2)));
maxheight = round(max(ROI_boundary_points_left(:,1)));
minheight = round(min(ROI_boundary_points_left(:,1)));
if maxheight>H
    maxheight = H;
end
im_X = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
im_Y = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
for h=1:maxheight-minheight+1
    im_X(h,:) = minheight+h-1;
    im_Y(h,:) = minwidth:maxwidth;
end
IN_face = inpolygon(im_X,im_Y,[ROI_boundary_points_left(:,1);ROI_boundary_points_left(1,1)],[ROI_boundary_points_left(:,2);ROI_boundary_points_left(1,2)]);
% create the mask for ROI 
mask_image = zeros(H,W);
mask_image(minheight:maxheight,minwidth:maxwidth) = IN_face;
inverse_mask_image = ~mask_image;
test_image(:,:,1)=inverse_mask_image.*videoFrame(:,:,1);
test_image(:,:,2)=inverse_mask_image.*videoFrame(:,:,2);
test_image(:,:,3)=inverse_mask_image.*videoFrame(:,:,3);
elseif side == 1
%%right side
ROI_boundary_points_right = [ROI_boundary_points(5,1),ROI_boundary_points(5,2);...
                     ROI_boundary_points(6,1),ROI_boundary_points(6,2);...
                     ROI_boundary_points(7,1),ROI_boundary_points(7,2);...
                     ROI_boundary_points(8,1),ROI_boundary_points(8,2);...
                     ROI_boundary_points(9,1),ROI_boundary_points(9,2)];
%%flip
ROI_boundary_points_right = round(fliplr(ROI_boundary_points_right));
videoFrame = double(videoFrame);
[H,W,~] = size(videoFrame);

%%narrow reigon
maxwidth = round(max(ROI_boundary_points_right(:,2)));
minwidth = round(min(ROI_boundary_points_right(:,2)));
maxheight = round(max(ROI_boundary_points_right(:,1)));
minheight = round(min(ROI_boundary_points_right(:,1)));
if maxheight>H
    maxheight = H;
end
im_X = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
im_Y = zeros(maxheight-minheight+1,maxwidth-minwidth+1);
for h=1:maxheight-minheight+1
    im_X(h,:) = minheight+h-1;
    im_Y(h,:) = minwidth:maxwidth;
end
IN_face = inpolygon(im_X,im_Y,[ROI_boundary_points_right(:,1);ROI_boundary_points_right(1,1)],[ROI_boundary_points_right(:,2);ROI_boundary_points_right(1,2)]);
% create the mask for ROI 
mask_image = zeros(H,W);
mask_image(minheight:maxheight,minwidth:maxwidth) = IN_face;
inverse_mask_image = ~mask_image;
test_image(:,:,1)=inverse_mask_image.*videoFrame(:,:,1);
test_image(:,:,2)=inverse_mask_image.*videoFrame(:,:,2);
test_image(:,:,3)=inverse_mask_image.*videoFrame(:,:,3);
end

end

