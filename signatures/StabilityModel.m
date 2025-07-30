function SignX = StabilityModel(A1)
%Calculate stability

  [row_num, col_num,k_num] = size(A1);
  
  for i=1:1:k_num
      B=A1(:,:,i);
      Mean(:,i)=mean(B,1);
  end
  Mean3=0;
  for i=1:1:k_num 
      Mean3=Mean(:,i)+Mean3;
  end
  Mean3=Mean3/k_num;
  
  for i=1:1:k_num 
      MeanQ(:,i)=Mean(:,i)-Mean3;
  end
  C = cov(MeanQ);
  F=eig(C);
  SP=abs(F'*C);
  SAA=mean(SP);
  Ms=0;
  
  for i=1:1:k_num
      SignX(i)=(SP(i)-SAA)*(SP(i)-SAA);
  end
end