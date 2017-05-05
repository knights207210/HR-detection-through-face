img = imread('chewi.png');


tic
output = dlibLandmarks('model.dat',img);
toc

imshow(img); hold on;
for i =1:68
    plot(output(i,1),output(i,2),'r*');
    hold on;
end