clear;clc;
%preprocessing , remove close-ups, lines and field extract.
list = dir('E:\Study\sem5\DIP\Project\photos\England_Brazil\*.jpg');

cd E:\Study\sem5\DIP\Project\photos\England_Brazil
ltg = 0.20;
utg = 0.25;
l=720;
b=1280;
per = 55;
breaks=[];
temp=0;
div =255*sqrt(l*b);
for i=850:2800
    im =imread(list(i).name);
    grey = double(rgb2gray(im));
    %
    if((norm(grey-temp))/div > 0.1)
      breaks = vertcat(breaks,i);
    end
    
    in =rgb2hsv(im);
    green = find(in(:,:,1) >ltg & in(:,:,1)<utg );
    
    if((length(green)/(l*b))*100 > per)
        i
    end
    temp=grey;
end