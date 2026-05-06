clc;clear;

load 'KSC.mat'; load 'KSC_gt.mat';
K = KSC./(max(KSC(:)));
proporition=0.99;
[m,n,d]=size(K);
redata=reshape(K,m*n,d); 
[coeff, pc2, latent]=pca(redata);
%% 计算累计贡献度，确认维度
sum_latent = cumsum(latent/sum(latent));  % 累计贡献率
dimension = find(sum_latent>proporition);

PCADATA = redata(:,25:27);
imgpca = reshape(PCADATA,m,n,3);


nC = 900;
%// Call the mex function for superpixel segmentation\
%// !!! Note that the output label starts from 0 to nC-1.
t = cputime;

lambda_prime = 0.3;sigma = 1.0; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).

[labels] = mex_ers(double(imgpca),nC,lambda_prime,sigma);
%[labels] = mex_ers(double(img),nC,lambda_prime,sigma);
%[labels] = mex_ers(double(img),nC,lambda_prime,sigma,conn8);

% grey scale iamge
%[labels] = mex_ers(grey_img,nC);
%[labels] = mex_ers(grey_img,nC,lambda_prime,sigma);
%[labels] = mex_ers(grey_img,nC,lambda_prime,sigma,conn8);

fprintf(1,'Use %f sec. \n',cputime-t);
fprintf(1,'\t to divide the image into %d superpixels.\n',nC);
grey_img = double(rgb2gray(imgpca));
%// You can also specify your preference parameters. The parameter values
%// (lambda_prime = 0.5, sigma = 5.0) are chosen based on the experiment
%// results in the Berkeley segmentation dataset.
%// lambda_prime = 0.5; sigma = 5.0;
%// [labels] = mex_ers(grey_img,nC,lambda_prime,sigma);
%// You can also use 4 connected-grid graph. The algorithm uses 8-connected 
%// graph as default setting. By setting conn8 = 0 and running
%// [labels] = mex_ers(grey_img,nC,lambda_prime,sigma,conn8),
%// the algorithm perform segmentation uses 4-connected graph. Note that 
%// 4 connected graph is faster.

[height width] = size(grey_img);


[bmap] = seg2bmap(labels,width,height);
bmapOnImg = imgpca;
idx = find(bmap>0);
timg = grey_img;
timg(idx) = 255;
bmapOnImg(:,:,2) = timg;
bmapOnImg(:,:,1) = grey_img;
bmapOnImg(:,:,3) = grey_img;

%// Randomly color the superpixels
[out] = random_color( double(imgpca) ,labels,nC);

%// Compute the superpixel size histogram.
siz = zeros(nC,1);
for i=0:(nC-1)
    siz(i+1) = sum( labels(:)==i );
end
[his bins] = hist( siz, 20 );

%%
%//=======================================================================
%// Display 
%//=======================================================================
gcf = figure(1);
subplot(2,3,1);
imshow(imgpca,[]);
title('input image.');
subplot(2,3,2);
imshow(bmapOnImg,[]);
title('superpixel boundary map');
subplot(2,3,3);
imshow(out,[]);
title('randomly-colored superpixels');
subplot(2,3,5);
bar(bins,his,'b');
title('the distribution of superpixel size');
ylabel('# of superpixels');
xlabel('superpixel sizes in pixel');
scnsize = get(0,'ScreenSize');
set(gcf,'OuterPosition',scnsize);

% save('ERS_LABELS_500.mat','labels','-V7');
save('KSC_ERS_LABELS_900.mat','labels','-V7');
%load ERS_LABELS_900.mat


