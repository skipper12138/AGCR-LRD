function L = lad_knn(X,sigma)
%计算每个字典原子的距离
[~,b]=size(X);
% d=pdist2(X',X');
%  d=pdist2(X',X','cosine'); %计算字典原子间的余弦相似度
 d=pdist2(X',X','seuclidean');
% d = real(d); 
% jkd=jaccard(X');
% d=d./jkd;
[q,index]=sort(mean(d),'descend');
c=ceil(0.5*b);
d(:,index(1:c))=0;d(index(1:c),:)=0;
W=exp((-d^2)/sigma);


% [d_i, d_j, d_v] = find(d);%找非0元素的行 列 值
% for i = 1: size(d)  
%     for j = 1: size(d)  
%         W(i, j) = exp(-d(i,j)^2/sigma);
%   % W(A_i(i), A_j(i)) = 1;
%     end
% end
% W = exp(-(d).^2/sigma);
D = sum(W(:,:),2);%D是对角线矩阵   
D=diag(D);
L = D-W;
% L = D^(1/2) * L * D^(1/2);
end