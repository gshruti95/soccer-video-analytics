old_angle = 0;

pitch_im = imread('pitch.png');
figure,imshow(pitch_im),hold on

% 1 - Top left corner
plot(90,50,'x','LineWidth',6,'Color','blue');
% 2 - Left bye line x Top left sideline
plot(90,290,'x','LineWidth',6,'Color','blue');
% 3 - Left bye line x Bot left sideline
plot(90,990,'x','LineWidth',6,'Color','blue');
% 4 - Bot left corner
plot(90,1230,'x','LineWidth',6,'Color','blue');
% 5 - Top left sideline x Left box line
plot(370,290,'x','LineWidth',6,'Color','blue');
% 6 - Bot left sideline x Left box line
plot(370,990,'x','LineWidth',6,'Color','blue');
% 7 - Top right corner
plot(1910,50,'x','LineWidth',6,'Color','blue');
% 8 - Right bye line x Top right sideline
plot(1910,290,'x','LineWidth',6,'Color','blue');
% 9 - Right bye line x Bot right sideline
plot(1910,990,'x','LineWidth',6,'Color','blue');
% 10 - Bot right corner
plot(1910,1230,'x','LineWidth',6,'Color','blue');
% 11 - Top right sideline x Right box line
plot(1630,290,'x','LineWidth',6,'Color','blue');
% 12 - Bot right sideline x Right box line
plot(1630,990,'x','LineWidth',6,'Color','blue');
% 13 - Top of center line
plot(1000,50,'x','LineWidth',6,'Color','blue');


view_left = 0;
view_right = 0;
view_centre = 0;
angle = 0;
angle_determined = 0;
if exists_line_centre == 1
    if points(13).xy(1) > (1280/2) + 300
        view_left = 1;
    elseif points(13).xy(1) < (1280/2) - 300
        view_right = 1;
    else
        view_centre = 1;
    end
%     angle = atan2((1280/2)-points(13).xy(1),norm(line_centre.point1 - line_centre.point2));
    angle = atan2((1280/2)-points(13).xy(1),1500);
    angle = rad2deg(angle);
    angle_determined = 1;
end
if exists_point_5 == 1
    view_left = 1;
%     angle = atan2((1280/2)-points(5).xy(1),norm([points(5).xy(1) points(5).xy(2)] - [(1280/2) 720]));
    angle = atan2((1280/2)-points(5).xy(1),1500);
    angle = rad2deg(angle);
    angle = angle - 35;
    angle_determined = 1;
end
if exists_point_11 == 1
    view_right = 1;
%     angle = atan2((1280/2)-points(11).xy(1),norm([points(11).xy(1) points(11).xy(2)] - [(1280/2) 720]));
    angle = atan2((1280/2)-points(11).xy(1),1500);
    angle = rad2deg(angle);
    angle = angle + 35;
    angle_determined = 1;
end

if angle_determined == 0
    angle = old_angle;
end
if no_lines == 1
    if old_angle > 0
        angle = 30;
    elseif old_angle < 0
        angle = -30;
    else
        angle = 0;
    end
end
old_angle = angle;
% angle=-45;
r = 1000;
y = r*cos(deg2rad(angle));
x = r*sin(deg2rad(angle));
% if angle < 0
%     x = -x;
% end
plot([1000 (1000+x)],[1230 (1230-y)],'LineWidth',6,'Color','red');


