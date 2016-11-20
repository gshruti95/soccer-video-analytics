
%list=dir('./*.jpg');

% img1 = imread('./images/pop_cut 00021.jpg');
img1 = im;

se1 = strel('disk',2);
se2 = strel('disk',17);
r=img1(:,:,1);
g=img1(:,:,2);
b=img1(:,:,3);
mask = (r<120)&(g>90)&(b<80);

im_hsv = rgb2hsv(img1);
low = 80/360; high = 150/360;
[a,b]=find(im_hsv(:,:,1) > low & im_hsv(:,:,1) < high);
green = zeros(size(img1,1), size(img1,2),3);

for i=1:size(a)
   green(a(i),b(i),:) = img1(a(i),b(i),:); 
end

bim = im2bw(green,.1);
bim = imerode(bim,strel('disk',10));
compl= ~bim;
%figure, imshow(compl);

im_open = imopen(mask,se1);
%figure, imshow(im_open);
ic=imcomplement(im_open);
%figure, imshow(ic);  %1

ic2 = imopen(ic,se2);
ic2 = imdilate(ic2,strel('disk',10));
%figure, imshow(ic2); %2
white = find(ic2==1); 
%ic(white)=0;
compl(white)=0;
compl = imerode(compl,strel('disk',9));
%figure, imshow(compl);
%figure, imshow(ic);

%ic = imopen(ic,strel('line',10,10));
%ic = imerode(ic,strel('disk',2));
%figure, imshow(ic);  %3

mask_im = bsxfun(@times, img1, cast(ic,class(img1)));
%figure, imshow(mask_im); %4

CC1 = bwconncomp(compl);
S1 = regionprops(CC1,'Area');
L1 = labelmatrix(CC1);
gmask1 = ismember(L1, find([S1.Area] >= 200));
gmask1 = imclearborder(gmask1);
%figure, imshow(gmask1); %5

regs = regionprops(gmask1, 'Area', 'Centroid', 'BoundingBox');

 figure()
 image(img1);
 axis image
 hold on
 for k = 1:length(regs)
    rectangle('position', regs(k).BoundingBox,'edgecolor','r','linewidth',1);
     plot(regs(k).Centroid(1), regs(k).Centroid(2), 'cx');
 end
 hold off
 
 
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% R1=imhist(img1(:,:,1));
% G1=imhist(img1(:,:,2));
% B1=imhist(img1(:,:,3));
% fin_hsv = rgb2hsv(uint8(fin1));
% fin_h = fin_hsv(:,:,1);
% fin1 = uint8(fin1);
% %figure, plot(fin_h);
% %figure, plot(R1); figure, plot(G1); figure, plot(B1);
% 
