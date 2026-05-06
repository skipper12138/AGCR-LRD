%% 此ROC曲线计算代码可以也可以用matlab自带roc函数：[PD, PF, thresholds]=roc(mask2, A); 

function  [auc,X,Y] = ROC1( predict, ground_truth )  
% INPUTS  
%  predict       - 分类器对测试集的分类结果  
%  ground_truth - 测试集的正确标签,这里只考虑二分类，即0和1  
% OUTPUTS  
%  auc            - 返回ROC曲线的曲线下的面积  
% %% 自己写的ROC计算代码 用和李伟老师的对比看看 
%初始点为（1.0, 1.0）  
x= 0;  
y= 0;  
%计算出ground_truth中正样本的数目pos_num和负样本的数目neg_num  
pos_num = sum(ground_truth==1);  
neg_num = sum(ground_truth==0);  
%根据该数目可以计算出沿x轴或者y轴的步长  
x_step = 1.0/neg_num;  
y_step = 1.0/pos_num;  
[~,index] = sort(predict,"descend"); 
ground_truth= ground_truth(index);  
%对predict中的每个样本分别判断他们是FP或者是TP  
%遍历ground_truth的元素，  
%若ground_truth[i]=1,则TP减少了1，往y轴方向下降y_step  
%若ground_truth[i]=0,则FP减少了1，往x轴方向下降x_step  
for i=1:length(ground_truth)  
    if ground_truth(i) == 1  
        y = y + y_step;  
    else  
        x = x + x_step;  
    end  
   X(i)=x;
   Y(i)=y;
end  
%计算小矩形的面积,返回auc  
auc = trapz(X,Y);
end 

% % % % 李伟老师代码里的计算roc的代码 
% mask = ground_truth;
% anomaly_map = logical(double(mask)>=1);
% normal_map = logical(double(mask)==0);
% r0=predict';
% r_max = max(r0(:));
% taus = linspace(0, r_max, 5000);
% for index2 = 1:length(taus)
%     tau = taus(index2);
%     anomaly_map_rx = (r0 > tau);
%     PF(index2) = sum(anomaly_map_rx & normal_map)/sum(normal_map);
%     PD(index2) = sum(anomaly_map_rx & anomaly_map)/sum(anomaly_map);
% end
% auc =  sum((PF(1:end-1)-PF(2:end)).*(PD(2:end)+PD(1:end-1))/2);
% X=PF;
% Y=PD;