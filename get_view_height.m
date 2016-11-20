vert_thresh = im2bw(rgb2gray(uint8(green_im)),0.1);

vert_thresh = imresize(vert_thresh,0.25);
eroded = imerode(vert_thresh,strel('disk',4));
dilated_pre = imdilate(eroded,strel('disk',4));
dilated = imdilate(dilated_pre,strel('line',200,0));

dilated_edge = edge(dilated);
figure,imshow(dilated_edge);
[H,T,R] = hough(dilated_edge);
P  = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));
lines = houghlines(dilated_edge,T,R,P,'FillGap',1,'MinLength',5);
angle_sum = 0;
length_sum = 0;
for i=1:length(lines)
    len = norm(lines(i).point1 - lines(i).point2);
    length_sum = length_sum + len;
    if lines(i).theta > 0
        angle_sum = angle_sum + len.*(90 - lines(i).theta);
    end
    if lines(i).theta < 0
        angle_sum = angle_sum + len.*(-lines(i).theta - 90); %?
    end
end
angle_sum = angle_sum ./ length_sum;

top_sum = 0;
bot_sum = 0;
for i = 1:size(dilated,2)
    index = find(dilated(:,i),10,'first');
    top_sum = top_sum + mean(index);
    bot_index = find(dilated(:,i),1,'last');
    bot_sum = bot_sum + bot_index;
end

top_sum = top_sum./size(dilated,2);
top_sum = round(top_sum.*4);

bot_sum = bot_sum./size(dilated,2);
bot_sum = round(bot_sum.*4);

figure,imshow(im),hold on
plot([1280 1],[top_sum top_sum],'LineWidth',2,'Color','red');
plot([1280 1],[bot_sum bot_sum],'LineWidth',2,'Color','red');

