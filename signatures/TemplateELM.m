function Ratio = TemplateELM(folderPathorg_File,folderPathforg_File,lay)
% ELM

folderPath=folderPathorg_File;
folderPathX=folderPathforg_File;

i=lay;
m=1;
for j=1:1:30
    imagePath=sprintf('%s\\original_%d_%d.png',folderPath,i,j);    
    
    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath);
    [row_num(j), col_num(j),k_num(j)] = size(image);
end

for j=1:1:30
    imagePath=sprintf('%s\\original_%d_%d.png',folderPath,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath); 
    row_numX=uint16(mean(row_num));
    col_numX=uint16(mean(col_num));        
    image=double(imresize(image,[row_numX,col_numX]));
    img3 =image;
    a = img3(:);
    a=a';
    Data(m,1)=1;
    gd=double(row_numX)*double(col_numX)+1;
    Data(m,2:1:gd)=a;
    m=m+1;
end

 for j=1:1:30
    imagePath=sprintf('%s\\forgeries_%d_%d.png',folderPathX,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath); 
    [row_num(j), col_num(j),k_num(j)] = size(image);
end

for j=1:1:30
    imagePath=sprintf('%s\\forgeries_%d_%d.png',folderPathX,i,j);    

    if ~exist(imagePath,'file')
        break;
    end        
    image = imread(imagePath); 
    row_numX=uint16(mean(row_num));
    col_numX=uint16(mean(col_num));        
    image=double(imresize(image,[row_numX,col_numX]));
    img3 = image;
    a = img3(:);
    a=a';
    Data(m,1)=2;
    gd=double(row_numX)*double(col_numX)+1;
    Data(m,2:1:gd)=a;
    m=m+1;
end

dataSet=Data;                          
len_dataSet = size(dataSet,1);                         
ind = randperm(len_dataSet);                           
train_set = dataSet(1:len_dataSet,:);
test_set = dataSet(1:len_dataSet,:);

[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELMA(train_set, test_set, 1, 20, 'sig');%sig

Ratio=TestingAccuracy;
end
    
    

