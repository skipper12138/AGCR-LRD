function [ DataMat,   DictMat,CoefMat ] = Initilization_DL( Data , Label, DictSize,  lambda1,lambda2)
% In this intilization function, we do the following things:
% 1. Random initialization of dictioanry pair D and P for each class
% 2. Precompute the class-specific inverse matrix used in Eq. (10)
% 3. Compute matrix class-specific code matrix A by Eq. (8) 
%    with the random initilized D and P
%
% The randn seeds are setted to make sure the results in our paper are
% reproduceable. The randn seed setting can be removed, our algorithm is 
% not sensitive to the initilization of D and P. In most cases, different 
% initilization will lead to the same recognition accuracy on a wide randge
% of testing databases.


ClassNum = max(Label);
Dim      = size(Data,1);
I_Mat    = eye(Dim,Dim);

for i=1:ClassNum
    TempData  = Data(:,Label==i);
    DataMat{i} = TempData;
    randn('seed',i);  
    DictMat{i}    = normcol_equal(randn(Dim, DictSize));
%      DictMat{i}    = ones(Dim, DictSize);
%     randn('seed',2*i);
%     P_Mat{i}      = normcol_equal(randn(Dim, DictSize))';
%     TempDataC     = Data(:,Label~=i);
%     DataInvMat{i} = inv(tau*TempData*TempData'+lambda*TempDataC*TempDataC'+gamma*I_Mat);
end
CoefMat =  utlize_xishu(  DictMat, DataMat,  lambda1,lambda2, DictSize  );

