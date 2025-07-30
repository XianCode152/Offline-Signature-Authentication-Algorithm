function Segimg = Seg(image)
%Image Segmentation

A1=image;
[row_num, col_num,k_num] = size(image);

if(k_num==3)
    A1 = rgb2gray(image);
end
[row_num, col_num] = size(A1);

clear Qtop;
clear Qbottom;
 
 for m=1:10:250
   clear Q1;
   clear Q2; 
   m;
   a=1;
   b=1;
     for i=1:10:row_num
        for j=1:10:col_num
            AF=A1(i,j);
            if(AF>m)
                Q1(a)=AF;
                a=a+1;
            end
            if(AF<=m)
                Q2(b)=AF;
                b=b+1;                     
            end
        end
     end
     
     if(a>=2&&b>=2)
        Qtop(m+1)=kEntropy(Q1,2,2,2);    
        Qbottom(m+1)=kEntropy(Q2,2,2,2); 
     end
 end
 
  [row_X, col_X] = size(Qtop);
 
 for j=1:1:col_X
     if (Qtop(j)==0||Qtop(j)==NaN||Qbottom(j)==0||Qbottom(j)==NaN)
         af(j)=1000;
     else
         aff=(Qtop(j)+Qbottom(j)-1)*(1-Qtop(j)+Qbottom(j));
         af(j)=(255-aff)/(255+aff);
     end
 end
         
         
 AF=Qtop+Qbottom-1;
 AB=1-Qtop+Qbottom;
 QW=AF.*AB;
 af=(255-QW)./(255+QW);
 
 ag=1000;
 for i=1:1:5
     [min_val, idx] = min(af);
     if ag>idx
         af(idx)=1000;
         ag=idx;
     end
 end
 
 if (ag<=150)
     ag=150;
 end
 
 for i=1:1:row_num
     for j=1:1:col_num
         if(A1(i,j)>ag+20)
             B1(i,j)=0;
         else
             B1(i,j)=1;
         end
     end
 end
 
 BW2 = bwareaopen(B1,5,8); 
 B1=uint8(BW2);
 
 for i=1:1:row_num
     for j=1:1:col_num
         if(BW2(i,j)==1)
             B1(i,j)=255;
         else
             B1(i,j)=0;
         end
     end
 end
 
 Segimg=B1;
end