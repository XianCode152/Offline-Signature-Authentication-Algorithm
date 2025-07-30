function FuzEn=kEntropy(data,dim,r,n)
%Calculate the fuzzy entropy£¬

data = data(:)';
data=double(data);
N =length(data);
phi = zeros(1,2);
r=r*std(data);%

for m= dim:dim+1
    count = zeros(N-m+1,1);
    dataMat=zeros(N-m+1,m); 
    
    for i = 1:N-m+1
      dataMat (i,:)= data(1,i: i+m-1)-mean(data(1,i:i+m-1));
    end

    for j= 1:N-m+1
        tempmat=repmat(dataMat(j,:),N-m+1,1);
        dist = max(abs(dataMat - tempmat),[],2);
        
        D=exp(-(dist.^n)/r);
        count(j)=(sum(D)-1)/(N-m-1);
    end
    phi(m-dim+1)= sum(count)/(N-m);
end
    FuzEn=log(phi(1)/phi(2));
end
