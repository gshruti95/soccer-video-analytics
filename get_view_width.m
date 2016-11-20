
%Try to get center line
centre_found = 0;
thresh = im2bw(L,0.3125);
% figure,imshow(thresh);
[H,T,R] = hough(thresh);
P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
lines = houghlines(thresh,T,R,P,'FillGap',10,'MinLength',300);
if size(lines,2)>0
    for i=1:size(lines,2)
        if lines(i).theta > -3 && lines(i).theta < 3
            centre_found = 1;
            centre_line = lines(i);
            break;
        end
    end
end
%Work with center line coordinates


% width_thresh = edge(dilated_pre);
width_thresh = edge(im2bw(uint8(green_im_3(:,:,1)),0.3));

[H,T,R] = hough(width_thresh);
P  = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));
lines = houghlines(width_thresh,T,R,P,'FillGap',5,'MinLength',20);

% figure, imshow(width_thresh), hold on
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end

% Determine if left half or right half
side_img = imresize(dilated_pre,1);
left_percent = 0;
right_percent = 0;
margin = round(top_sum/4);
for i = margin:margin+10
    for j = 1:size(side_img,2)/2
        left_percent = left_percent + side_img(i,j);
    end
    for j = size(side_img,2)/2:size(side_img,2)
        right_percent = right_percent + side_img(i,j);
    end
end
left_percent = left_percent / (10*(size(side_img,2)/2));
right_percent = right_percent / (10*(size(side_img,2)/2));
hor_feature = dilated;

left_sided = 0;
right_sided = 0;
if (left_percent > 0.75 || right_percent > 0.75) && (abs(left_percent-right_percent)>0.5)
    if left_percent < right_percent
        angle_low = 70;
        angle_high = 85;
        left_sided = 1;
    else
        angle_low = -85;
        angle_high = -70;
        right_sided = 1;
    end
    if size(lines,2) > 0
        angle = 0;
        count = 0;
        for i=1:size(lines,2)
            if (lines(i).theta > angle_low && lines(i).theta < angle_high)
                angle = angle + lines(i).theta;
                count = count + 1;
            end
        end

        if count > 0
            angle = angle./count;
        end

        dilated_hor = imdilate(dilated_pre,strel('line',300,90-angle));
        hor_feature = imerode(dilated_hor,strel('line',10,180-angle));
    else
        disp('Else');
    end

end

figure,imshow(dilated);
figure,imshow(hor_feature);
