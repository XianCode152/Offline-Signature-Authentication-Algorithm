function [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELMA(train_data, test_data, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%% ELM
% [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)

%% Data preprocessing

REGRESSION=0;
CLASSIFIER=1;

T=train_data(:,1)';                   
P=train_data(:,2:size(train_data,2))';
clear train_data;                    

TV.T=test_data(:,1)';                 
TV.P=test_data(:,2:size(test_data,2))';
HF=test_data(:,2:size(test_data,2))';
FG=pinv(HF);
clear test_data;                      

NumberofTrainingData=size(P,2);        
NumberofTestingData=size(TV.P,2);      
NumberofInputNeurons=size(P,1);       

%% Data encoding
if Elm_Type~=REGRESSION
    sorted_target=sort(cat(2,T,TV.T),2);
    label=zeros(1,1);              
    label(1,1)=sorted_target(1,1);     
    j=1;

    for i = 2:(NumberofTrainingData+NumberofTestingData)
        if sorted_target(1,i) ~= label(1,j)
            j=j+1;
            label(1,j) = sorted_target(1,i);
        end
    end
    number_class=j;                    
    NumberofOutputNeurons=number_class;
       
    temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
    
    for i = 1:NumberofTrainingData
        for j = 1:number_class
            if label(1,j) == T(1,i)
                break; 
            end
        end
        temp_T(j,i)=1;              
    end
    T=temp_T*2-1;                    

    temp_TV_T=zeros(NumberofOutputNeurons, NumberofTestingData);
    for i = 1:NumberofTestingData
        for j = 1:number_class
            if label(1,j) == TV.T(1,i)
                break; 
            end
        end
        temp_TV_T(j,i)=1;           
    end
    TV.T=temp_TV_T*2-1;              


end  % Elm_Type

%% Calculate the output H of the hidden layer
start_time_train=cputime;          

InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1; 
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);                
tempH=InputWeight*P; 
clear P;
ind=ones(1,NumberofTrainingData);     
BiasMatrix=BiasofHiddenNeurons(:,ind);
tempH=tempH+BiasMatrix;               

switch lower(ActivationFunction) % 
    case {'sig','sigmoid'}
        H = 1 ./ (1 + exp(-tempH));% Sigmoid
    case {'sin','sine'}
        H = sin(tempH);            % Sine 
    case {'hardlim'}
        H = double(hardlim(tempH));% Hardlim 
    case {'tribas'}
        H = tribas(tempH);         % Triangular basis
    case {'radbas'}
        H = radbas(tempH);         % Radial basis
              
end
clear tempH;

%% OutputWeight (beta_i)
OutputWeight=pinv(H') * T';   

end_time_train=cputime;
TrainingTime=end_time_train-start_time_train; 

Y=(H' * OutputWeight)';                     
if Elm_Type == REGRESSION 
    TrainingAccuracy=sqrt(mse(T - Y));       
end
clear H;

%% Calculate the output of the test data (prediction label)
start_time_test=cputime;  
tempH_test=InputWeight*TV.P;
clear TV.P;  

ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind); 
tempH_test=tempH_test + BiasMatrix;
switch lower(ActivationFunction)
    case {'sig','sigmoid'}% Sigmoid  
        H_test = 1 ./ (1 + exp(-tempH_test));
    case {'sin','sine'}   % Sine 
        H_test = sin(tempH_test);        
    case {'hardlim'}      % Hardlim 
        H_test = hardlim(tempH_test);        
    case {'tribas'}       % Triangular basis 
         H_test = tribas(tempH_test);        
    case {'radbas'}       % Radial basis 
         H_test = radbas(tempH_test);        
           
end
TY=(H_test' * OutputWeight)';                     

end_time_test=cputime;
TestingTime=end_time_test-start_time_test;          

%% Calculation accuracy rate
if Elm_Type == REGRESSION
    TestingAccuracy=sqrt(mse(TV.T - TY));          
end

if Elm_Type == CLASSIFIER 
    MissClassificationRate_Training=0;
    MissClassificationRate_Testing=0;
    
    for i = 1 : size(T, 2) 
        [x, label_index_expected]=max(T(:,i));
        [x, label_index_actual]=max(Y(:,i));
        if label_index_actual~=label_index_expected
            MissClassificationRate_Training=MissClassificationRate_Training+1;
        end
    end

    mA1=0;
    mA2=0;
    for i=1:1:size(TY, 2)
        GU=abs(TY(1,i));
        TG(i)=T(1,i);
        if(GU<0.1)
            G(:,1)=HF(:,i);
            X=FG*G;
            for j=1:1:size(X, 1)
               if(T(1,j)==1)
                   mA1=mA1+abs(X(j));
               end
               if(T(1,j)==-1)
                   mA2=mA2+abs(X(j));  
               end
            end

            if(mA1>mA2)
                TY(1,i)=abs(TY(1,i));
                TY(2,i)=-abs(TY(1,i));  
            else
                TY(1,i)=-abs(TY(1,i));
                TY(2,i)=abs(TY(1,i));
            end
        end  
    end
    
    TrainingAccuracy=1-MissClassificationRate_Training/size(T,2); 
    for i = 1 : size(TV.T, 2)
        [x, label_index_expected]=max(TV.T(:,i));
        [x, label_index_actual]=max(TY(:,i));
        if label_index_actual~=label_index_expected
            MissClassificationRate_Testing=MissClassificationRate_Testing+1;
        end
    end
    TestingAccuracy=1-MissClassificationRate_Testing/size(TV.T,2); 
end