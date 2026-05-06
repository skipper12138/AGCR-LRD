function S=saliency_g(data,data1,m,n)
band_num=3;
band_set=OCF_simplify(data1',band_num);
% 从data1中选择相应的波段组成一个集合
% gdata=gradient(data1);
data11=data1(:,band_set);
gdata=gradient(data11);
redata=reshape(gdata,m,n,band_num);
% M=m*n;
% X_mean = mean(data1);%求均值
% T= data1-repmat(X_mean,M,1);%将均值扩充L倍，减去均值
% Sigma = (T'* T)/M; %协方差矩阵
% Sigma_inv=pinv(Sigma);%RN的协方差矩阵求逆
% % ans=T(1,:).'*T(1,:)/M;
% for x= 1:M
%     D(x) = T(x,:)* (Sigma_inv) * T(x,:)';  %RX计算公式
% end
% D=mat2gray(D);

img_gr=rgb2gray(redata);

img  = im2double(img_gr);
%% Do FFT and get amplitude A, L(f)=log(A(f)) and phase P(f)
f = fft2(img);%首先对图像进行傅里叶变换

% data=img;
% [M,N,L]=size(data);
% data1=zeros(M,N,L);
% p=0.7;
% alpha=p*pi/2;                                                             % rotation angle
% A=exp(-1j*pi*sign(sin(alpha))/4+1j*alpha/2)/sqrt(sin(alpha));             % A_alpha
% [s,u]=meshgrid(1:L,1:L);
%  Kp_su=A.*exp(1j*pi.*(s.^2*cot(alpha)-2*s.*u*csc(alpha)+u.^2*cot(alpha))); % K_p(u,v)
% for i=1:M
%     for j=1:N
%         data1(i,j,:)=abs(reshape(data(i,j,:),1,L)*Kp_su);                 % FrFT of each pixel
%     end
% end
L = log(abs(f));%求傅里叶变换后的图像的对数
P = angle(f);%处理过程中保留的图像的相位谱
%% calculate the statistical singularities R(f)
k=3;
H(1:k,1:k)=1/(k*k);
flimg= imfilter(L, H, 'replicate');
R = L - flimg;
S = abs(ifft2(exp(R + i*P))).^2;
%% And then do inverse Fourier transform, use a Gaussian fuzzy filter to get the significant area.
G=imfilter(S, fspecial('Gaussian', [10, 10],1));%高斯滤波器的窗口大小和标准差
S = mat2gray(G);
S=(S-min(S(:)))/(max(S(:))-min(S(:)));
end

