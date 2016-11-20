clear all
list = dir('./images');
for count = 3:15
    close all
    [im,green_im] = get_pitch(strcat('./images/',list(count).name));
    get_white_lines
    field
    visualize_view
    playerid
    pause
end