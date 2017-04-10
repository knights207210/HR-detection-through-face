function [ database ] = add_database( options )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
flag = getParam('database');

if flag == 1
    database.num_video = 527;
    database.path_video ='';
    %etc
elseif flag == 2
    database.num_video = input('please input the number of video in database:\n');
    %etc
end

end

