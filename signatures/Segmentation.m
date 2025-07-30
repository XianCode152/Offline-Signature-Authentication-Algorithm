function Segmentation(folderPathIN,folderPathOUT)

folderPath = folderPathIN;
imageFiles = dir(fullfile(folderPath, '*.png')); 

for i = 1:length(imageFiles)
imagePath = fullfile(folderPath, imageFiles(i).name); 
img = imread(imagePath);

Segimg = Seg(img);

OutfolderPath=folderPathOUT;
OutimagePath = fullfile(OutfolderPath, imageFiles(i).name); 
imwrite(Segimg,OutimagePath);
end