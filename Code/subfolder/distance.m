function [ d ] = distance (point1,point2)
%this function is used to calculate the distance between tow points
width = abs(point1(1)-point2(1));
height = abs(point1(2)-point2(2));
d = sqrt(width*width+height*height);


end

