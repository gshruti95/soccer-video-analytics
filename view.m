
%function frame_list = view(f_name,start,frames)

%I1 = imread(f_name);
I1=imread ('pop_cut/pop_cut 00001.jpg');
R1=imhist(I1(:,:,1));
G1=imhist(I1(:,:,2));
B1=imhist(I1(:,:,3));

HD = [];
    
%for i=(start+1):1600
 for i = 2:1600   
    I2=imread (strcat('pop_cut/pop_cut 0',num2str(i,'%04i'),'.jpg'));
    R2=imhist(I2(:,:,1));
    G2=imhist(I2(:,:,2));
    B2=imhist(I2(:,:,3));
    HD(i-1) = sum(sum(abs(R2-R1)))+sum(sum(abs(G2-G1)))+sum(sum(abs(B2-B1)));
    R1 =R2;
    G1 = G2;
    B1 = B2;
    
end

%arr = HD;
pos =[];

for i=11:length(HD)-10
	sum1 = 0;
	sum2 = 0;
    
	for j=1:10
		sum1=sum1+HD(i-j);
		sum2=sum2+HD(i+j);
    end
    
	avg1=sum1/10;
	avg2=sum2/10;
    
	if (HD(i)>5*avg1 && HD(i)>5*avg2)
		pos = [pos,i];
    end
    
end

% frame_list = [];

% for i=1:length(pos)
%     if pos(i) <= (start + frames)
%         frame_list = [frame_list,pos(i)];
%     end
% end

plot(HD);

%end
