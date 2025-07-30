function HandwritingExtraction (folderPathorgIN1,folderPathorgIN2,folderPathorgOUT)

folderPath1=folderPathorgIN1;
folderPath2=folderPathorgIN2;

imageFiles = dir(fullfile(folderPath1, '*.png')); 

for i = 1:length(imageFiles)
    imagePath1 = fullfile(folderPath1, imageFiles(i).name);
    image1 = imread(imagePath1);
    
    [row_num1, col_num1,k_num1] = size(image1);
    A1=image1;
    if(k_num1==3)
        A1 = rgb2gray(image1);
    end
    
    
    imagePath2 = fullfile(folderPath2, imageFiles(i).name); 
    image2 = imread(imagePath2);
    [row_num2, col_num2,k_num2] = size(image2);
    A2=image2;
    if(k_num2==3)
        A2= rgb2gray(image2);
    end
 
     top=row_num2;bottom=0;
     SA = sum(A2, 2);
     for j=1:1:row_num2
         if(SA(j)~=0&&j<top)
             top=j;
         end
         if(SA(j)~=0&&j>bottom)
             bottom=j;
         end
     end
     
     left=col_num2; right=0;
     SB = sum(A2, 1);
     for j=1:1:col_num2
         if(SB(j)~=0&&j<left)
             left=j;
         end
         if(SB(j)~=0&&j>right)
             right=j;
         end
     end   
     
     subMatrix1 = A1(top:bottom, left:right);
     subMatrix2 = A2(top:bottom, left:right);    
     subMatrix1(subMatrix2==0)=0;

     OutimagePath1 = fullfile(folderPathorgOUT, imageFiles(i).name); 
     imwrite(subMatrix1,OutimagePath1);
end