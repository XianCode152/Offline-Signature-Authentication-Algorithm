function SignatureProcessing(folderPathorgIN,folderPathforgIN,folderPathorgOUT,folderPathforgOUT)

%Segmentation
Segmentation(folderPathorgIN,folderPathorgOUT);
Segmentation(folderPathforgIN,folderPathforgOUT);

 %Handwriting Extraction
folderPathorgIN1=folderPathorgIN;
folderPathorgIN2= folderPathorgOUT;
folderPathorgOUT1='E:\U\Chinese\full_orgA\44';
HandwritingExtraction (folderPathorgIN1,folderPathorgIN2,folderPathorgOUT1);

folderPathforgIN1=folderPathforgIN;
folderPathforgIN2= folderPathforgOUT;
folderPathforgOUT2='E:\U\Chinese\full_forgB\44';
HandwritingExtraction (folderPathforgIN1,folderPathforgIN2,folderPathforgOUT2);

%Handwriting Discrimination
HandwritingDiscrimination(folderPathorgOUT,folderPathforgOUT);

end




