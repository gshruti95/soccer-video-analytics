%clear all; close all;
function regs = block(f_name)

img1 = imread(f_name);
%img1 = imread('pop_cut/pop_cut 00001.jpg');

%%%%%%%%%%%%%%%%%%%%%%%
%se1 = strel('disk',2);
%se2 = strel('disk',17);

% im_hsv = rgb2hsv(img1);
% low = 80/360; high = 150/360;
% 
% [a,b]=find(im_hsv(:,:,1) > low & im_hsv(:,:,1) < high);
% green = zeros(size(img1,1), size(img1,2),3);
% 
% for i=1:size(a)
%    green(a(i),b(i),:) = img1(a(i),b(i),:); 
% end
% 
% %figure, imshow(uint8(green));
% bim = im2bw(green,.1);
% figure, imshow(~bim);
% bim = imerode(bim,strel('disk',9));
% compl= ~bim; 
% figure, imshow(compl);
%%%%%%%%%%%%%%%%%%%%%%%%%

% HSV mask
hsv_im = rgb2hsv(img1);
h = hsv_im(:,:,1);
gmask = 360*h > 65 & 360*h < 120;
compl = ~imerode(gmask,strel('disk',10));
%figure, imshow(compl);

%%%%%%%%% RGB 
r=img1(:,:,1);
g=img1(:,:,2);
b=img1(:,:,3);
rgb_mask = (r<120)&(g>90)&(b<80);
%figure, imshow(rgb_mask);
im_open = imopen(rgb_mask,strel('disk',2));
%figure, imshow(im_open);
im_openc=imcomplement(im_open);
%figure, imshow(im_openc), title('Rgb mask');  

im_openc2 = imopen(im_openc,strel('disk',17));
im_openc2 = imdilate(im_openc2,strel('disk',10));
%figure, imshow(im_openc2);
%im_openc2 = imclose(im_openc2,strel('disk',10));
%figure, imshow(im_openc2); 
white = (im_openc2==1); 

compl(white)=0;
%figure, imshow(compl);
compl = imerode(compl,strel('disk',9));
%figure, imshow(compl);

%mask_im = bsxfun(@times, img1, cast(ic,class(img1)));

CC1 = bwconncomp(compl);
S1 = regionprops(CC1,'Area');
L1 = labelmatrix(CC1);
gmask1 = ismember(L1, find([S1.Area] >= 200));
%gmask1 = imclearborder(gmask1);
%figure, imshow(gmask1); 

regs = regionprops(gmask1, 'Area', 'Centroid', 'BoundingBox');

 figure(1)
 image(img1);
 axis image
 hold on
 for k = 1:length(regs)
    rectangle('position', regs(k).BoundingBox,'edgecolor','r','linewidth',1);
     plot(regs(k).Centroid(1), regs(k).Centroid(2), 'cx');
     
 end
 hold off

end  
    

