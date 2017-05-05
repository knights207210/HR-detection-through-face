function [options] = set_options

options = C_params('method Parameter');    %set name
options.sDate =  datestr(now,'dd-mm-yy_HH-MM');   %set time

%signal video or a whole database
%fprintf('Which kind of input?\n');
%flag_inputtype=input('Press: Single video[1]/Complete database[2]:\n');
%fprintf('\n');
flag_inputtype = 1;
options.addParam('inputtype', flag_inputtype);


%calculte the groundtruth or import directly
fprintf('Do you want to calculate the groundtruth\n?');
flag_calgt=input('Press: calculate the groundtruth[1] or import the groundtruth[2] or do not need to calculate[3]\n');
fprintf('\n');
options.addParam('calgt',flag_calgt);

%calculte the colortraces or import directly
fprintf('Do you want to calculate the color traces and landmarks\n?');
flag_calcolortraces =input('Press: calculate the color traces and landmarks[1] or import the color traces and landmarks[2]\n');
fprintf('\n');
options.addParam('calcolortraces',flag_calcolortraces);

%set parameters manually or not
%fprintf('Do you want to use defalut parameters or set them mannually\n?');
%flag_setparameters=input('Press: defalut parameters[1]/set parameters mannually[2]:\n');
%fprintf('\n');
options.addParam('setparameters',2);
end


