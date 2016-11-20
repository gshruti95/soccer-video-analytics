cd E:\Study\sem5\DIP\Project\photos1\pop_cut
%Camera wide screen
list=dir('./*.jpg');
se1 = strel('disk',7);
se2 = strel('disk',25);
ball=[];
load('E:\Study\sem5\DIP\Project\Codes\rec')
load('E:\Study\sem5\DIP\Project\Codes\rec2')
load('E:\Study\sem5\DIP\Project\Codes\rec3')
j=1;
thresh = 25;
thresh2=4;
for i=4945:5075%:size(list,1)
    im=imread(list(i).name);
    gray = rgb2gray(im);
    bw=im2bw(im);
    
    
   if i==316%458
%        imshow(im)
%     box = imrect();
%     rect = wait(box);
%     rec = im(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
    
   else
       %rec = im(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
   end
   
   
    
    
%   figure,imshow(im);
    r=im(:,:,1);
    g=im(:,:,2);
    b=im(:,:,3);
    mask = (r<120)&(g>90)&(b<80);    %green (<120,>90,<80)
    mask_im = bsxfun(@times, im, cast(mask,class(im)));
    
    im_open = imopen(mask,se1);
    ic=imcomplement(im_open); %LINES WHITE
    ic2 = imopen(ic,se2); %ground is black and no lines: Where ever this is white make it black in ic
%     figure,imshow(mask_im);
%     figure,imshow(mask)
    white = find(ic2==1); 
    ic(white)=0;
    %figure,imshow(ic);
   % figure,imshow(im_open);
    [H,T,R] = hough(ic);
    P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(ic,T,R,P,'FillGap',10,'MinLength',7);
     
    %figure,imshow(ic2),hold on;
    ground = find(ic2 ==1);
    gray(ground) = 0;
    
    %figure,imshow(rec)
    c = normxcorr2(rec,gray);
    c2 = normxcorr2(rec2,gray);
    c3= normxcorr2(rec3,gray);
    l = [max(c(:)),max(c2(:)),max(c3(:))];
    k = find(l==max(l));
    if(k==1)
    [ypeak, xpeak]= find(c==max(c(:))); %norxcorr2 adds padding 
    elseif(k==2)
        [ypeak, xpeak]= find(c2==max(c2(:)));
    else
        [ypeak, xpeak]= find(c3==max(c3(:)));
    end
    
    %figure(1),imshow(im);hold on 
    %rectangle('position',[xpeak(1)-size(rec,2), ypeak(1)-size(rec,1), size(rec,2), size(rec,1)],'EdgeColor','r');
    max_len = 0;
    
    x=xpeak(1)-size(rec,2); %new co-ordinates... 
    y= ypeak(1)-size(rec,1);
    
    if j==1
        rect(1)=x;
        rect(2)=y;
        j=j+1;
    end
    
    dis = pdist2([rect(2),rect(1)],[y,x]);
    %rectangle('position',[x, y, size(rec,2), size(rec,1)],'EdgeColor','b');
    if(dis>thresh2*sqrt(size(rec,1)^2+size(rec,2)^2))
           i
       px = rect(1);%not center.
       py= rect(2);
       
       miy = min(size(gray,1),py+thresh);
       mix = min(size(gray,2),px+thresh);
%        may= max(1,py-thresh);
%        maix = max(1,px-thresh);
       part= gray(py:miy,px:mix);
       bp = im2bw(part);
       [yb,xb]=find(bp==1);
       if(isempty(xb))
           xb=0;
       end
       if(isempty(yb))
           yb=0;
       end
       x = px-floor(thresh/2)+floor(median(xb));
       y = py-floor(thresh/2)+floor(median(yb));
       
    end
       %rectangle('position',[x,y, size(rec,2), size(rec,1)],'EdgeColor','r');
    rect(1)=x;
    rect(2)=y;
    %print('-f1',strcat('E:\Study\sem5\DIP\Project\output/',sprintf('%04d',i-4944)),'-dpng')
    ball = [ball;rect];
    
    
%     for k = 1:length(lines)
%         xy = [lines(k).point1; lines(k).point2];
%         plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%         
%         % Plot beginnings and ends of lines
%         plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%         plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%         
%         % Determine the endpoints of the longest line segment
%         len = norm(lines(k).point1 - lines(k).point2);
%         if ( len > max_len)
%             max_len = len;
%             xy_long = xy;
%         end
%     end


end