function Ratio = TemplateMatching(folderPathorg_File,folderPathforg_File,lay)
% Template Matching
m=1;
i=lay;

for j=1:1:30
    imagePath=sprintf('%s\\original_%d_%d.png',folderPathorg_File,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath);
    [row_num(j), col_num(j),k_num(j)] = size(image);
end

for j=1:1:30
    imagePath=sprintf('%s\\original_%d_%d.png',folderPathorg_File,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath); 
    row_numX=uint16(mean(row_num));
    col_numX=uint16(mean(col_num));        
    image=double(imresize(image,[row_numX,col_numX]));
    img3 =image;
    Data(:,:,m)=img3;
    DataA(:,:,m)=img3;
    Sign(m)=1;   
    m=m+1;  
end

for j=1:1:30
    imagePath=sprintf('%s\\forgeries_%d_%d.png',folderPathforg_File,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath); 
    image=double(imresize(image,[row_numX,col_numX]));
    img3 = image;
    Data(:,:,m)=img3;  
    Sign(m)=2;
    m=m+1; 
end
Res=0;
[row_num, col_num,k_num] = size(Data);
[row_numA, col_numA,k_numA] = size(DataA);    
for j=1:1:k_num
    VC=100000;
    for k=1:1:k_numA
        U=abs(Data(:,:,j)-DataA(:,:,k));
        VCA=sum(sum(U))/(row_num*col_num);
        if(VCA<VC)
            VT(i,j)=VCA;
            VC=VCA;
        end
    end
    
    if (VC<14)
        Signres(j)=1;
    else
        Signres(j)=2;
    end
end

Res=0;
for j=1:1:k_num
    if ( Signres(j)== Sign(j))
        Res=Res+1;
    end
end

Ratio=Res/k_num;
end
