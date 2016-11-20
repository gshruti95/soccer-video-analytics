function [im,green_im] = get_pitch(f_name)
% im = imread('pop_cut 00021.jpg');
im = imread(f_name);

im_hsv = rgb2hsv(im);
% im_lab = rgb2lab(im);
% L = uint8(im_lab(:,:,1));

low = 80/360;
high = 150/360;

[a,b] = find(im_hsv(:,:,1) > low & im_hsv(:,:,1) < high);
[x,y] = find(im_hsv(:,:,1) < low | im_hsv(:,:,1) > high);
green_im = zeros(size(im,1),size(im,2),3);
green_im_2 = zeros(size(im,1),size(im,2),3);
green_im_3 = zeros(size(im,1),size(im,2),3);

for i = 1:size(a)
    green_im(a(i),b(i),:) = im(a(i),b(i),:);
    green_im_3(a(i),b(i),:) = (green_im(a(i),b(i),:) - 75)*(255./(155-75));
end
for i = 1:size(x)
    green_im_2(x(i),y(i),:) = im(x(i),y(i),:);
%     green_im(x(i),y(i),2) = 200;
end

figure,imshow(uint8(green_im));
figure,imshow(uint8(green_im_2));
figure,imshow(uint8(green_im_3));
end
