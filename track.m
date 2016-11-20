close all; clear all;

% Starting frame and number of frames
start = 4715; frames = 200;

list = dir('pop_cut/*.jpg');
f_name = strcat('pop_cut/', list(start).name);

%frame_list = view(f_name,start,frames);
frame_list = [];
regs1 = block(f_name);
flag = 0;

now = zeros(100,2);
prev = zeros(100,2);

for i=1:length(regs1)
    
    regs1(i).hist = i;
    prev(i,1) = round(regs1(i).Centroid(1));
    prev(i,2) = round(regs1(i).Centroid(2));
    text(round(regs1(i).BoundingBox(1)),round(regs1(i).BoundingBox(2)),num2str(i));
    
end

maps_no = 0;

for l=1:length(frame_list)
    if l==1
        fprintf('ent l=1\n');
        maps_no = frame_list(1) - start;
        fprintf('maps = %i\n',maps_no);
    elseif mod(l,2) == 0
        
        if l == length(frame_list)
            maps_no = maps_no + frames+start - frame_list(l) ;
        end
        fprintf('ent even maps=%i l=%i\n',maps_no,l);
        
    else
        maps_no = maps_no + frame_list(l) - (frame_list(l-1) + 1) ;
        fprintf('ent odd maps=%i l=%i\n',maps_no,l);
    end
  
end

if maps_no == 0
    maps_no = frames;
end

cmap = zeros(100,100,maps_no);
box_num = zeros(100,maps_no);
min_d = 10000;

if ~isempty(frame_list)
    p=1;
    if length(frame_list) == 1
        frames = frame_list(p);
    end
end

i = start+1;
cnt = 0;

while (i<=frames+start) 
   
    if ~isempty(frame_list)
        
        if mod(p,2) ~= 0  %% Skip frames in odd p
            
            fprintf('ent odd p=%i i=%i\n',p,i);
            
            if i >= (frame_list(p) + 1)
                fprintf('ent i=48.. i=%i\n',i);
                if (p+1) > length(frame_list)
                    break;
                else 
                    i = frame_list(p+1) + 1;
                    p = p+1;
                    flag = 1; %% Reset history buffer
                    fprintf('ent else in 48 ... i=%i p=%i flag=%i\n',i,p,flag);
                end

            end

       else %% Iterate if even p
            
            fprintf('ent even p=%i i=%i\n',p,i);
            
            if (p+1) <= length(frame_list)  
                fprintf('ent if in even\n');
                if i == frame_list(p+1) + 1
                    if (p+2) > length(frame_list)
                        break;
                    else    
                        p = p+1;
                        continue;
                    end
                end
            end
            
        end % end check even or odd p
        
    end % end check view
    
   if flag == 1 %% Change in view, reset buffer
       fprintf('ent flag=1 p=%i i=%i\n',p,i);
       flag = 0;
       f_name = strcat('pop_cut/', list(i).name);
       regs1 = block(f_name);
     
       now = zeros(23,2);
       prev = zeros(23,2);

       for x=1:length(regs1)

           regs1(x).hist = x;
           prev(x,1) = round(regs1(x).Centroid(1));
           prev(x,2) = round(regs1(x).Centroid(2));
           text(round(regs1(x).BoundingBox(1)),round(regs1(x).BoundingBox(2)),num2str(x));

       end
    
   else
        cnt = cnt + 1;
       f_name = strcat('pop_cut/', list(i).name);
        regs2 = block(f_name);

        for j=1:length(regs2) %% For each box in current frame

            now(j,1) = round(regs2(j).Centroid(1));
            now(j,2) = round(regs2(j).Centroid(2));
            min_d = 10000;
                
            for k=1:max(length(regs2),length(regs1))  %% Compare with each box in prev frame

                xsq = (now(j,1) - prev(k,1))^2;
                ysq = (now(j,2) - prev(k,2))^2;
                dist = xsq + ysq;
                cmap(j,k,cnt) = dist;

                if dist < min_d
                    min_d = dist;
                    box_num(j,cnt) = k;
                end

            end

            %if length(regs1) < j
            
           % elseif box_num(j,cnt) == 0
            %    free_num = max([regs2.hist])+1;
             %   regs2(j).hist = free_num;
              %  text(round(regs2(j).BoundingBox(1)),round(regs2(j).BoundingBox(2)),num2str(regs2(j).hist));
                
            if box_num(j,cnt) ~= 0
                if length(regs1) >= box_num(j,cnt)
                regs2(j).hist = regs1(box_num(j,cnt)).hist;
                text(round(regs2(j).BoundingBox(1)),round(regs2(j).BoundingBox(2)),num2str(regs2(j).hist));
                end
            end
            % Label current frame box as box with min_d of prev frame
            
        end
        
        for j=1:length(regs2)
            if  box_num(j,cnt) == 0
                    free_num = max([regs2.hist])+1;
                    regs2(j).hist = free_num;
                    text(round(regs2(j).BoundingBox(1)),round(regs2(j).BoundingBox(2)),num2str(regs2(j).hist));
            end
        end
        
   end
   
   print('-f1',strcat('./video/',sprintf('%04d',i),'-dpng'));
    i = i+1;
end


