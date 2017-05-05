function [ ROI_boundary_points ] = HR_getROI_points(facial_landmarks,CParams)
%
%select 8 facial landmarks to define ROI, the landmark numbers are
%2,4,6,9,12,14,,16,29


width1=(facial_landmarks.points(16,1)-facial_landmarks.points(2,1))*0.05;
width2=(facial_landmarks.points(14,1)-facial_landmarks.points(4,1))*0.05;
width3=(facial_landmarks.points(12,1)-facial_landmarks.points(6,1))*0.05;
height=(facial_landmarks.points(9,2)-facial_landmarks.points(29,2))*0.1;
nose_shift=(facial_landmarks.points(29,1)-facial_landmarks.points(2,1))*0.2;
height2=(facial_landmarks.points(6,2)-facial_landmarks.points(4,2))*0.4;


ROI_boundary_points=[facial_landmarks.points(2,1)+width1,facial_landmarks.points(2,2);...
                     facial_landmarks.points(4,1)+width2,facial_landmarks.points(4,2);...
                     facial_landmarks.points(6,1)+width3,facial_landmarks.points(6,2)-height2;...
                     facial_landmarks.points(34,1),facial_landmarks.points(34,2);...
                     facial_landmarks.points(12,1)-width1,facial_landmarks.points(12,2)-height2;...
                     facial_landmarks.points(14,1)-width2,facial_landmarks.points(14,2);...
                     facial_landmarks.points(16,1)-width3,facial_landmarks.points(16,2);...
                     facial_landmarks.points(29,1)+nose_shift,facial_landmarks.points(29,2)+height;...
                     facial_landmarks.points(29,1)-nose_shift,facial_landmarks.points(29,2)+height];


end

