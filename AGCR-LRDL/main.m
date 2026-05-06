close all;
clear;
clc;
addpath(genpath(pwd));
data_number=1;
[data, data1, M, m, n,b, mask]=load_data(data_number);
tic
%% ERS 超像素分割
figure,imagesc(reshape(mask,m,n));axis image;
proporition=0.99;
redata=data1;%data11 DATA11
[coeff, pc2, latent]=pca(redata);
% 计算累计贡献度，确认维度
sum_latent = cumsum(latent/sum(latent));  % 累计贡献率
dimension = find(sum_latent>proporition);
PCADATA =redata(:,1:3); %25:27
imgpca = reshape(PCADATA,m,n,3);

% for i=20:5:50
%     for j=2:5
nC=20;
t = cputime;
lambda_prime = 0.3;sigma = 1.0; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).
[labels] = mex_ers(double(imgpca),nC,lambda_prime,sigma,conn8);
fprintf(1,'Use %f sec. \n',cputime-t);
fprintf(1,'\t to divide the image into %d superpixels.\n',nC);

%% 字典学习（Dictionary Learning）
part_id=cell(nC,1); %分成k个同质区域
trDc=[];
ind1=[];
labels1=ones(m,n)+labels;
for block=1:nC %在每一个超像素块中按照步长选择一部分训练数据
dataY=(redata(find(labels1==block),:));

dis=pdist2(dataY,dataY);%计算每个超像素块里面的各个像素之间的距离
[dissum,index]=sort((mean(dis,2)));
part_id{block,1}=(redata(find(labels1==block),:))'; % 波段数*样本数 %选择初始的训练数据
class_num(block,1)=size(part_id{block,1},2);%每一类的原子个数
n1=ceil(0.05*size(part_id{block,1},2));  %从每类中随机选择5%的原子当做初始数据
step=ceil(size(part_id{block,1},2)/n1);     %%按步长选择原子
order=1:step:size(part_id{block,1},2);      %%按步长选择原子
ordernew=index(order);
ind=block*ones(1,n1);
ind1=[ind1,ind]; %标签类别 

A=part_id{block,1}(:,ordernew); %idx1 order  按步长选择原子
trDc=[trDc,A]; %选择的训练数据合集
end
DictSize =2;     %决定字典D的个数(nC*DictSize)

lambda1  = 0.01;
lambda2 = 0.01;
Max_iteration =50;
[DataMat, DictMat, CoefMat] = Initilization_DL( trDc , ind1, DictSize,  lambda1, lambda2);%ind1
[D_Mat,Coef]=DL_TRA(DataMat,ind1,lambda1,lambda2,DictMat,CoefMat,Max_iteration);%ind1
Dic=[];
for ii=1:size(D_Mat,2)
   Dic=[Dic, D_Mat{1,ii}];
end

Dict=Dic';
lambda=1e-6;
betla=1e-5;
[result]=func_GCR(data,data1,Dict,lambda,betla,1);
SG=saliency_g(data,data1,m,n);
SL=saliency_l(nC,labels,data1,m,n);
R1= reshape(result,M,1);
Smap=SL+SG;
S0=reshape(Smap,M,1);
[St,index]=sort(S0,'descend');
[Rt,index1]=sort(R1,'descend');
mm=ceil(0.01*M);
ww1=intersect(index(1:mm),index1(1:mm));

St(ww1)=1;Rt(ww1)=1;Smap=reshape(St.*Rt,m,n);
% 
c=1;%调节参数
r=result.*(exp(c.*reshape(Smap,m,n)));
r = (r - min(r(:))) / (max(r(:)) - min(r(:)));
figure,imagesc(r);axis image;
toc;
det_map=reshape(r,M,1);
GT=reshape(mask,M,1);
[auc,x,y]=ROC1(det_map,GT);
mode_eq=1;
[AUC_D_F,AUC_D_tau,AUC_F_tau,AUC_TD,AUC_BS,AUC_SNPR,AUC_TDBS,AUC_ODP]=plot_3DROC(det_map,GT,mode_eq);

time=toc;
FP_GCRLRDL=x;
TP_GCRLRDL=y;
tmp_GCRLRDL=r;
time_GCRLRDL=time;
mask_GCRLRDL=mask;
save ('E:\study\matlab\duibi\GCRLRDL', 'AUC_D_F', 'AUC_F_tau', 'AUC_TD','AUC_BS','AUC_SNPR','AUC_TDBS','AUC_ODP','FP_GCRLRDL', 'TP_GCRLRDL', 'tmp_GCRLRDL','time_GCRLRDL','mask_GCRLRDL');
