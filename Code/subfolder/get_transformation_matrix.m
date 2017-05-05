function [transformation_matrix_for]=get_transformation_matrix(video)

disp('transmat');
% Store transformation_matrix.

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% get frame and detect

videoFileReader = vision.VideoFileReader(video.path);
for k=1:video.firstFrame
    [~]=step(videoFileReader);
end

videoFrame      = step(videoFileReader);
bbox            = step(faceDetector, videoFrame);
[h,w]=size(bbox);


% because sometimes it may find two or more boxes, we use the large one 
if h*w>4
  tmpSize = 0;
  for i = 1:h
   sizeBox = bbox(i,3)*bbox(i,4);
   if(tmpSize < sizeBox)
     tmpSize = sizeBox;
     finalBox =bbox(i,:);
   end
  end
  bbox = finalBox;   
end

%objectImage = insertShape(videoFrame, 'Rectangle', bbox,'Color', 'red');
%figure; imshow(objectImage); title('Red box shows object region');

% Detect feature points in the face region.
points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', bbox);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Initialize the tracker with the initial point locations and the initial
% video frame.
initPoints = points.Location;
initialize(pointTracker, initPoints, videoFrame);

%% plotting for debugging
%pointImage = insertMarker(videoFrame, points, '+', 'Color', 'white');
%imshow(pointImage);
%drawnow;
%subject =video.subject;
%trail   =video.trail;
%export_fig(['/tmp/' num2str(subject) '_t_'  num2str(trail) '.png']);
% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
oldPoints = initPoints;

%numFrames = video.numFrames;
%foreward tracking
transformNum=0;
%for n=video.initFrame+1:numFrames % old code (video.lastFrame+32*video.fps)
    % get the next frame
    %videoFrame = video.frames(n).data;
videoFileReader = vision.VideoFileReader(video.path);
for k=1:video.firstFrame
    [~]=step(videoFileReader);
end
for n=1:(video.lastFrame+32*video.fps)
    % get the next frame
    videoFrame = step(videoFileReader);

    % Track the points. Note that some points may be lost.
    [points, isFound] = step(pointTracker, videoFrame);
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);

    if size(visiblePoints, 1) >= 2 % need at least 2 points

        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
          transformNum = transformNum+1;
        transformation_matrix_for{transformNum}=xform;

        % Reset the points
        oldPoints = visiblePoints;
        setPoints(pointTracker, oldPoints);
    else
      error('not enough points for tracking');
        
    end
    %('.');
end

% backward tracking
%release(pointTracker);
%pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
%videoFrame   = video.frames(video.initFrame).data;
%initialize(pointTracker, initPoints, videoFrame);
%transformNum=0;
%oldPoints = initPoints;

%for n=video.initFrame-1:-1:1 % old code (video.lastFrame+32*video.fps)
    % get the next frame
    %videoFrame = video.frames(n).data;

    % Track the points. Note that some points may be lost.
    %[points, isFound] = step(pointTracker, videoFrame);
    %visiblePoints = points(isFound, :);
    %oldInliers = oldPoints(isFound, :);

    %if size(visiblePoints, 1) >= 2 % need at least 2 points

        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        %[xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            %oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
        %transformNum = transformNum+1;
        %transformation_matrix_back{transformNum}=xform;

        % Reset the points
        %oldPoints = visiblePoints;
        %setPoints(pointTracker, oldPoints);
    %else
      %error('not enough points for tracking');
        
    %end
    %('.');
%end

% Clean up
release(pointTracker);
end