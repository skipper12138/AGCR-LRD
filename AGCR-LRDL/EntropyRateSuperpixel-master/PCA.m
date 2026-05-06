function [ mu,sigma,coeff,score,latent ] = PCA( originalData )
% originalData——原始数据，每行代表一组；
% 标准化数据：mu-每列的均值；sigma-每列的标准差;
% PCA降维数据：coeff-系数矩阵；score-PCA降维结果;latent-所有主成分的影响率（%）。
 
%训练时：
%1、数据标准化，并保存标准化所用的参数；
%2、PCA降维；
%3、选择维度（一般选择累计影响率大于95%的前几个维度），并保留所用的样本均值和系数矩阵；
 
 
%1、数据标准化：Z-标准化后的数据；mu-每列的均值；sigma-每列的标准差。
[Z,mu,sigma]=zscore(originalData);
%2、PCA降维：
[coeff,score,latent] = princomp(Z);
%3、选择维度
latent=100*latent/sum(latent);
A=length(latent);
percent_threshold=95;           %百分比阀值，用于决定保留的主成分个数；
percents=0;                          %累积百分比
for n=1:A
    percents=percents+latent(n);
    if percents>percent_threshold
        break;
    end
end
coeff=coeff(:,1:n);               %达到主成分累积影响率要求的系数矩阵；
score=score(:,1:n);              %达到主成分累积影响率要求的主成分；<br>save PCA mu sigma coeff latent
end