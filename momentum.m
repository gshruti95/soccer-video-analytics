clear all
list = dir('./images');
mom = [];
set(0,'DefaultFigureVisible','off');
for count = 4744:4744+100
    close all
    [im,green_im] = get_pitch(strcat('./images/',list(count).name));
    close all
    get_white_lines
    close all
    visualize_view
    close all
    if angle == 0
        angle = -22.5;
    end
    [mom] = [mom angle];
end
set(0,'DefaultFigureVisible','on');