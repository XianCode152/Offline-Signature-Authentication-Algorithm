function HandwritingDiscrimination(folderPathorgIN,folderPathforgIN)

folderPathorg_File = folderPathorgIN;
folderPathforg_File = folderPathforgIN;

g=1;
for i=1:1:55
    clear imgX;
    g1=1;    
    for j=1:1:30
        imagePath=sprintf('%s\\original_%d_%d.png',folderPathorg_File,i,j);    
        
        if exist(imagePath,'file')
            g1=0;
        end   
        
        if ~exist(imagePath,'file')
            g=0;
            break;
        end        
        image = imread(imagePath);
        [row_num(j), col_num(j),k_num(j)] = size(image);
    end
    if (g==0&&g1==1)
        break; 
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
        img3 = mat2gray(image);
        imgX(:,:,j)=img3;
    end
    SignX = StabilityModel(imgX);
    SignT=sum(SignX)*power(10,13);
    
    if(SignT>16000)
        TestingAccuracy = TemplateMatching(folderPathorg_File,folderPathforg_File,i);
        fprintf('%d Data Accuracy rate£º%g \n',i,TestingAccuracy);
    else
        TestingAccuracy = TemplateELM(folderPathorg_File,folderPathforg_File,i);
        fprintf('%d Data Accuracy rate£º%g \n',i,TestingAccuracy);   
    end
end
