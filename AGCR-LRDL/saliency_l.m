function S=saliency_l(nC,labels,data1,m,n)
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
% nC =100; % 分割的超像素个数
% 
% t = cputime;
% lambda_prime = 0.3;sigma = 1.0; 
% conn8 = 1; % flag for using 8 connected grid graph (default setting).
% [labels] = mex_ers(double(imgpca),nC,lambda_prime,sigma,conn8);

dx=(1:m);Dx=repmat(dx',1,n);
dy=(1:n);Dy=repmat(dy,m,1);
label=labels+1;
% supimage=[];supDxk=[];supDyk=[];
sigma1=1;
S=zeros(m*n,1);
for k=1:nC
    image=data1(find(label==k),:);
%     image=gradient(image);
    [p,q]=size(image);
    Dxk=Dx(find(label==k));%第k个元素的横坐标
    Dyk=Dy(find(label==k));%第k个元素的纵坐标
    tt=length(find(label==k));
    Si=zeros(tt,tt);
    for i=1:tt
        dxi=Dxk(i);dyi=Dyk(i); spei=image(i,:);%超像素块中第i个元素的光谱向量
        Dxi=repmat(dxi,p,1);Dxij=Dxi-Dxk;
        Dyi=repmat(dyi,p,1);Dyij=Dyi-Dyk;
        Spei=repmat(spei,p,1);
        spat=sqrt(Dxij.^2+Dyij.^2);
        spec=(sum((Spei-image).^2,2));
        si=spec.*(exp(-(spat.^2)./sigma1));
        Si(:,i)=si; 
    end
    Sij=mean(Si);
    S(find(label==k))=Sij';
end
S=reshape(S,m,n);
end
