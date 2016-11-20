
green_im_lab = rgb2lab(green_im);
L = uint8(green_im_lab(:,:,1));
thresh = im2bw(L,0.33);
thresh2 = imdilate(thresh,strel('disk',2));
% figure,imshow(thresh2);

[H,T,R] = hough(thresh2);
P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
lines = houghlines(thresh2,T,R,P,'FillGap',40,'MinLength',350);
figure, imshow(thresh2), hold on
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

no_lines = 0;
if isempty(lines)
    %Probably in the region between the centre and one of two penalty areas
    no_lines = 1;
end

exists_line_centre = 0;
exists_line_left_box_top = 0;
exists_line_left_box_bot = 0;
exists_line_left_box = 0;
exists_line_left_bye = 0;
exists_line_right_box_top = 0;
exists_line_right_box_bot = 0;
exists_line_right_box = 0;
exists_line_right_bye = 0;
%If multiple detected, keep the longer one TODO
for i=1:length(lines)
    % Centre line -3 to 3
    if lines(i).theta >= -3 && lines(i).theta <=3
        line_centre = lines(i);
        exists_line_centre = 1;
    end
    % Left Box top sideline -87
    if lines(i).theta <= -86 && lines(i).theta >= -88
        line_left_box_top = lines(i);
        exists_line_left_box_top = 1;
    end
    % Left Box bottom sideline -84
    if lines(i).theta <= -83 && lines(i).theta >= -85
        line_left_box_bot = lines(i);
        exists_line_left_box_bot = 1;
    end
    % Left 18 yard line 71/72
    if lines(i).theta <= 73 && lines(i).theta >= 70
        line_left_box = lines(i);
        exists_line_left_box = 1;
    end
    % Left bye line 78
    if lines(i).theta <= 79 && lines(i).theta >= 77
        line_left_bye = lines(i);
        exists_line_left_bye = 1;
    end
    % Right Box top sideline Empirically 87 (Never detected yet because Brazil didn't attack much :P)
    if lines(i).theta <= 88 && lines(i).theta >= 86
        line_right_box_top = lines(i);
        exists_line_right_box_top = 1;
    end
    % Right Box bottom sideline 84
    if lines(i).theta <= 85 && lines(i).theta >= 83
        line_right_box_bot = lines(i);
        exists_line_right_box_bot = 1;
    end
    % Right 18 yard line -72/-73
    if lines(i).theta <= -70 && lines(i).theta >= -74
        line_right_box = lines(i);
        exists_line_right_box = 1;
    end
    % Right bye line -78
    if lines(i).theta <= -77 && lines(i).theta >= -79
        line_right_bye = lines(i);
        exists_line_right_bye = 1;
    end
end


points = struct('xy',{0,0,0,0,0,0,0,0,0,0,0,0,0});
% Find important points
% 1 - Top left corner
% 2 - Left bye line x Top left sideline
% 3 - Left bye line x Bot left sideline
% 4 - Bot left corner
% 5 - Top left sideline x Left box line
% 6 - Bot left sideline x Left box line
% 7 - Top right corner
% 8 - Right bye line x Top right sideline
% 9 - Right bye line x Bot right sideline
% 10 - Bot right corner
% 11 - Top right sideline x Right box line
% 12 - Bot right sideline x Right box line
% 13 - Top of center line
exists_point_5 = 0;
exists_point_11 = 0;

figure,imshow(im),hold on
% 1 - Top left corner
if exists_line_left_bye == 1
    points(1).xy = line_left_bye.point2;
    plot(points(1).xy(1),points(1).xy(2),'x','LineWidth',6,'Color','blue');
end
% 2 - Left bye line x Top left sideline
if exists_line_left_bye == 1 && exists_line_left_box_top == 1
    Q1 = line_left_bye.point1;
    Q2 = line_left_bye.point2;
    P = line_left_box_top.point1;
    d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
    if d < 10
        points(2).xy = line_left_box_top.point1;
        plot(points(2).xy(1),points(2).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 3 - Left bye line x Bot left sideline
if exists_line_left_bye == 1 && exists_line_left_box_bot == 1
    Q1 = line_left_bye.point1;
    Q2 = line_left_bye.point2;
    P = line_left_box_bot.point1;
    d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
    if d < 10
        points(3).xy = line_left_box_bot.point1;
        plot(points(3).xy(1),points(3).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 4 - Bot left corner
if exists_line_left_bye == 1
    points(4).xy = line_left_bye.point1;
    plot(points(4).xy(1),points(4).xy(2),'x','LineWidth',6,'Color','blue');
end
% 5 - Top left sideline x Left box line
if exists_line_left_box_top == 1 && exists_line_left_box == 1
    if norm(line_left_box_top.point2 - line_left_box.point2) < 150
        points(5).xy = (line_left_box_top.point2 + line_left_box.point2)/2;
        points(5).xy(1) = round(points(5).xy(1));
        points(5).xy(2) = round(points(5).xy(2));
        exists_point_5 = 1;
        plot(points(5).xy(1),points(5).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 6 - Bot left sideline x Left box line
if exists_line_left_box_bot == 1 && exists_line_left_box == 1
    if norm(line_left_box_bot.point2 - line_left_box.point1) < 150
        points(6).xy = (line_left_box_bot.point2 + line_left_box.point1)/2;
        points(6).xy(1) = round(points(6).xy(1));
        points(6).xy(2) = round(points(6).xy(2));
        plot(points(6).xy(1),points(6).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 7 - Top right corner
if exists_line_right_bye == 1
    points(7).xy = line_right_bye.point2;
    plot(points(7).xy(1),points(7).xy(2),'x','LineWidth',6,'Color','blue');
end
% 8 - Right bye line x Top right sideline
if exists_line_right_bye == 1 && exists_line_right_box_top == 1
    Q1 = line_right_bye.point1;
    Q2 = line_right_bye.point2;
    P = line_right_box_top.point2;
    d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
    if d < 10
        points(8).xy = line_right_box_top.point2;
        plot(points(8).xy(1),points(8).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 9 - Right bye line x Bot right sideline
if exists_line_right_bye == 1 && exists_line_right_box_bot == 1
    Q1 = line_right_bye.point1;
    Q2 = line_right_bye.point2;
    P = line_right_box_bot.point2;
    d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
    if d < 10
        points(9).xy = line_right_box_bot.point2;
        plot(points(9).xy(1),points(9).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 10 - Bot right corner
if exists_line_right_bye == 1
    points(10).xy = line_right_bye.point1;
    plot(points(10).xy(1),points(10).xy(2),'x','LineWidth',6,'Color','blue');
end
% 11 - Top right sideline x Right box line
if exists_line_right_box_top == 0 && exists_line_right_box == 1
    points(11).xy = line_right_box.point1;
    points(11).xy(1) = round(points(11).xy(1));
    points(11).xy(2) = round(points(11).xy(2));
    exists_point_11 = 1;
    plot(points(11).xy(1),points(11).xy(2),'x','LineWidth',6,'Color','blue');
end
if exists_line_right_box_top == 1 && exists_line_right_box == 1
    if norm(line_right_box_top.point1 - line_right_box.point1) < 150
        points(11).xy = (line_right_box_top.point1 + line_right_box.point1)/2;
        points(11).xy(1) = round(points(11).xy(1));
        points(11).xy(2) = round(points(11).xy(2));
        exists_point_11 = 1;
        plot(points(11).xy(1),points(11).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 12 - Bot right sideline x Right box line
if exists_line_right_box_bot == 1 && exists_line_right_box == 1
    if norm(line_right_box_bot.point1 - line_right_box.point2) < 150
        points(12).xy = (line_right_box_bot.point1 + line_right_box.point2)/2;
        points(12).xy(1) = round(points(12).xy(1));
        points(12).xy(2) = round(points(12).xy(2));
        plot(points(12).xy(1),points(12).xy(2),'x','LineWidth',6,'Color','blue');
    end
end
% 13 - Top of center line
if exists_line_centre == 1
    points(13).xy = line_centre.point1; % OR POINT 2 if ANGLE > 0?
    plot(points(13).xy(1),points(13).xy(2),'x','LineWidth',6,'Color','blue');
end
