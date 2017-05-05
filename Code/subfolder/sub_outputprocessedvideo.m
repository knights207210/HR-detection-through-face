function [] = sub_outputprocessedvideo(frame,facial_landmarks,l)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% plot sub region
            points = facial_landmarks;
            pointImage = insertMarker(frame,points,'+','Color','white');
            ROI_boundary_points = ROI_points_dilb(points);
            ROI_points = ROI_boundary_points;
            ROI_boundarypointImage = insertMarker(pointImage,ROI_points,'*','Color','red');
            test_image = subregion_show(ROI_boundarypointImage,ROI_boundary_points,l-1);
            imshow(test_image);
end

