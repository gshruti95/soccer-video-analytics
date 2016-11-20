function a=playerid(img1,regs,p)

valr = [];
valg = [];
valb = [];
bra_color = [195 190 30];
ger_color = [50 35 45];
ref_color = [30 50 110];
% pitch_im = imread('pitch.png');
% figure,imshow(pitch_im),hold on


%regs has my output ...


centers=[];
label=[];
load('E:\Study\sem5\DIP\Project\Codes\ball')
pos=[];

ref_detected = 0;
for i = 1:length(regs)
%     rectangle('position', regs(i).BoundingBox,'edgecolor','r','linewidth',1);
%     plot(regs(i).Centroid(1), regs(i).Centroid(2), 'cx');
    top_left = [round(regs(i).BoundingBox(1)),round(regs(i).BoundingBox(2))];
    width = regs(i).BoundingBox(3);
    height = regs(i).BoundingBox(4);
    
    
    center= [top_left(1)+width/2,top_left(2)+height/2] ;
    centers = vertcat(centers,center);
  
    disp(1)
    sub_im = img1(top_left(2):min(top_left(2)+height,720),top_left(1):min(top_left(1)+width,1280),:);
    %figure,imshow(sub_im);
    r = sub_im(:,:,1);
    g = sub_im(:,:,2);
    b = sub_im(:,:,3);
    mask = (r<120)&(g>90)&(b<80);
    mask_im = bsxfun(@times, sub_im, cast(~mask,class(sub_im)));
    histr = imhist(mask_im(:,:,1));
    histg = imhist(mask_im(:,:,2));
    histb = imhist(mask_im(:,:,3));
    histr = histr(2:256);
    histg = histg(2:256);
    histb = histb(2:256);
    [~,rmax] = max(histr);
    [~,gmax] = max(histg);
    [~,bmax] = max(histb);
    [valr] = [valr rmax];
    [valg] = [valg gmax];
    [valb] = [valb bmax];
    bra_dist = pdist2(bra_color,[rmax,gmax,bmax]);
    ger_dist = pdist2(ger_color,[rmax,gmax,bmax]);
    ref_dist = pdist2(ref_color,[rmax,gmax,bmax]);
    [dist,index] = min([bra_dist,ger_dist,ref_dist]);
    
        
    label = vertcat(label,index);
    
%     x = top_left(1);
%     y = top_left(2);
%     player_angle = atan2(640 - x,1500);
%     player_angle = rad2deg(player_angle);
%     player_angle = -1.4*player_angle;
%     disp(player_angle);
% %     r = 2*(y + 300*(sin(deg2rad(player_angle))));
%     r = 2*y;
%     r = 3*y - 600*(sin(deg2rad(player_angle)));
%     if player_angle > 0
%         r = 3*y - 600*(sin(deg2rad(player_angle)));
%     else
%         r = 3*y + 2000*(sin(deg2rad(player_angle)));
%     end
%     y = r*cos(deg2rad(angle+player_angle));
%     x = r*sin(deg2rad(angle+player_angle));
%     if index == 1 %BRA
%         disp 'BRA'
%         plot((1000+x),(1230-y),'x','LineWidth',15,'Color','yellow');
%     elseif index == 2 % GER
%         disp 'GER'
%         plot((1000+x),(1230-y),'x','LineWidth',15,'Color','black');
%     elseif index == 3 && ref_detected == 0 % Ref
%         disp 'REF'
%         ref_detected = 1;
%         plot((1000+x),(1230-y),'x','LineWidth',15,'Color','cyan');
%     else
%         [dist1,index1] = min([bra_dist,ger_dist]);
%         if index1 == 1
%             disp 'BRA'
%             plot((1000+x),(1230-y),'x','LineWidth',15,'Color','yellow');
%         else
%             disp 'GER'
%             plot((1000+x),(1230-y),'x','LineWidth',15,'Color','black');
%         end
%     end
%     [val] = [val sub_im(round(size(sub_im,1)/2),round(size(sub_im,2)/2),:)];
    
end

    dis = pdist2(centers,ball(p,:)+10);
    po = find(dis==min(dis));
    pos= label(po(1));
    %dis
    %label
    a= pos ;
return 
