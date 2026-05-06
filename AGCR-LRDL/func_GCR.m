function [result]=func_GCR(data,data1,Dict,lambda,betla,sigma)
[a,b,~]=size(data);
M=a*b;
result=zeros(a,b);

for i=1:b
    for j=1:a
        y=squeeze(data(j,i,:));

%        for tt3=1:nums
%             jkc1=gradient(Dict(:,tt3));j_0=find(jkc1<=0);j_1=find(jkc1>0);
%             jkcy=gradient(y');j_10=find(jkcy<=0);j_11=find(jkcy>0);
%             D_00=length(intersect(j_0,j_10));
%             D_11=length(intersect(j_1,j_11));
%             jsc(tt3,:)=(D_00+D_11)/c;
%         end  
        %计算光谱梯度的信息散度
%         g_y=gradient(y);g_Dict=gradient(Dict);
%         for k=1:size(Dict,1)
%             Gamma(1,k)=norm((g_y'-g_Dict(k,:)),2);
%         end  
        for k=1:size(Dict,1)
            Gamma(1,k)=norm((y'-Dict(k,:)),2);
        end      
        Gamma_y=diag(Gamma);  % num_sam x num_sam 
        L=lad_knn(Dict',sigma);
        alpha=pinv(Dict*Dict'+lambda*(Gamma_y'*Gamma_y)+betla*(L))*Dict*y;
        result(j,i)=norm((y-Dict'*alpha), 2);
     end
 end
result=(result-min(result(:)))/(max(result(:))-min(result(:)));
end
        


