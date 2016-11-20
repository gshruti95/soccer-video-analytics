mowing_thresh = im2bw(uint8(green_im_3(:,:,1)),0.3);

figure,imshow(mowing_thresh);

mowing_thresh = edge(mowing_thresh);


[H,T,R] = hough(mowing_thresh);

P  = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));

lines = houghlines(mowing_thresh,T,R,P,'FillGap',10,'MinLength',75);
figure, imshow(im), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end