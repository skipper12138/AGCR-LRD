close all;
clear;
clc;
addpath(genpath(pwd));
data_number=22;
[data, data1, M, m, n,b, mask]=load_data(data_number);

Smask=reshape(mask,m,n);
% gi=gradient(data1);
% % [Res] = saliency_map(data, 5);
% % figure,imagesc(Res);axis image;
% tic
SG=saliency_g(data,data1,m,n);
 figure,imagesc(Smask);axis image;
figure,imagesc(SG);axis image;
% %% ERS 超像素分割
% %光谱值
% proporition=0.99;
% redata=data1;%data11 DATA11
% [coeff, pc2, latent]=pca(redata);
% % 计算累计贡献度，确认维度
% sum_latent = cumsum(latent/sum(latent));  % 累计贡献率
% dimension = find(sum_latent>proporition);
% PCADATA =redata(:,1:3); %25:27
% imgpca = reshape(PCADATA,m,n,3);
% 
nC =100; % 分割的超像素个数
% 
% t = cputime;
% lambda_prime = 0.3;sigma = 1.0; 
% conn8 = 1; % flag for using 8 connected grid graph (default setting).
% [labels] = mex_ers(double(imgpca),nC,lambda_prime,sigma,conn8);
% % S=saliency_map(data, 3);
% % % S=saliency(data,data1,m,n);
% % figure,imagesc(S);axis image;
dx=(1:m);Dx=repmat(dx',1,n);
dy=(1:n);Dy=repmat(dy,m,1);
% label=labels+1;
[labels,nums]=superpixels3(data,nC);label=labels(:,:,1);
% supimage=[];supDxk=[];supDyk=[];
sigma1=1;
S=zeros(m*n,1);
for k=1:nC
    image=data1(find(label==k),:);
%     image=gradient(image);
    [p,q]=size(image);
    Dxk=Dx(find(label==k));
    Dyk=Dy(find(label==k));
    tt=length(find(label==k));
    Si=zeros(tt,tt);Si1=zeros(tt,tt);
    for i=1:tt
        dxi=Dxk(i);dyi=Dyk(i); spei=image(i,:);
        Dxi=repmat(dxi,p,1);Dxij=Dxi-Dxk;
        Dyi=repmat(dyi,p,1);Dyij=Dyi-Dyk;
        Spei=repmat(spei,p,1);
        spat=sqrt(Dxij.^2+Dyij.^2);
        spec=sum((Spei-image).^2,2);
        si=spec.*(exp(-(spat.^2)./sigma1));
        Si(:,i)=si; 
%         for j=i+1:length(find(label==k))
%             dxj=Dxk(j);dyj=Dyk(j);
%             spej=image(j,:);
% %             SAD=(spei*spej')./(sqrt(spei*spei').*sqrt(spej*spej'));
%             spectral1=sum((spei-spej).^2);
%             spa1=sqrt((dxi-dxj).^2+(dyi-dyj).^2);
%             si=spectral1*(exp(-(spa1.^2)./sigma1));
%             Si1(i,j)=si;
%         end
%         Sij1=mean(Si1+Si1');
    end
    Sij=mean(Si);
    S(find(label==k))=Sij';
end
SL=reshape(S,m,n);
figure,imagesc(SL);axis image;
figure,imagesc(0.5*SL+0.5*SG);axis image;
% sigma=1;
% Si=zeros(nC,nC);
% for i=1:nC
%     spectrali=supimage(:,i);
%     spaitalxi=supDxk(i);spaitalyi=supDyk(i);
%     for j=1:nC
%         spectralj=supimage(:,j);
%         spaitalxj=supDxk(j);spaitalyj=supDyk(j);
%         SAD=(spectrali'*spectralj)./(sqrt(spectrali'*spectrali).*sqrt(spectralj'*spectralj));
%         spectral1=sum((spectrali-spectralj).^2);
%         spaital1=(spaitalxi-spaitalxj).^2+(spaitalyi-spaitalyj).^2;
%         si=spectral1*(exp(-spaital1./sigma));
%         Si(i,j)=si;
%     end
% end
% ASi=triu(Si,1); 
% BSi=ASi+ASi';
% Sum=sum(BSi);
% S=zeros(m*n,1);
% for i=1:nC
%     cell=find(label==i);
%     S(cell)=Sum(i);
% end
% S=reshape(S,m,n);
% figure,imagesc(S);axis image;