function [ D_Mat,Coef]=DL_TRA(DataMat,ind1,lambda1,lambda2,Dict,Coef,Max_iteration)

mu_max=1e10;
p0=1.1;
et=1e-3;
nClass = max(ind1);
% Jstep_T = 1e-3;

for ci = 1:nClass
    Y1=zeros(size(Coef{ci},1),size(Coef{ci},2)); %拉格朗日乘子初始值
    cdat = DataMat{ci};   
    temD=Dict{ci};
    yital=(norm(temD,2))^2;
    mu=1;
    
    iteration = 1;
    afa=Coef{ci};%设置初始值
    S=afa;%设置初始值
    while  iteration <=Max_iteration 
 
    % 引入辅助变量S,固定D和afa,update S_new
    Qk=afa-Y1./mu;
    tao=1./mu;
    [U, sigma, V]=svd(Qk, 'econ');
    sigma_new=diag(sigma);
    sigma_tao=sigma_new-tao;
    svp1=find(sigma_tao>0);
    svp2=find(sigma_tao<=0);
    sigma_new(svp1,1)=sigma_tao(svp1, 1);
    sigma_new(svp2,1)=0;
%     svp=find(sigma_new>tao);
%     svp2=find(sigma_new<-tao);
%     svp3=find(sigma_new<=tao & sigma_new>=-tao);
%     sigma_new(svp,1)=sigma_new(svp, 1)-tao;
%     sigma_new(svp2, 1)=sigma_new(svp2, 1)+tao;
%     sigma_new(svp3, 1)=0;
    
    sigma_new=diag(sigma_new);   
    S_new=U*sigma_new*V';

    %update afa
%     afa0=pinv(temD'*temD+(lambda1+lambda2+mu./2).*eye(size(temD,2)))*(temD'*cdat+(mu*S_new+Y1)./2);
    PinvD=pinv(temD'*temD+(lambda1+lambda2+mu./2).*eye(size(temD,2)));
    avg_afa = repmat(mean(S_new,2),[1 size(S_new,2)]);
    afa_new = PinvD*(temD'*cdat+(mu*S_new+Y1)./2+lambda2*avg_afa);
      
    Coef{ci}=afa_new;%     C(ci).M = afa;
    
%    update D
    for i=1:size(temD,2)
        ai        =    afa_new(i,:);
        Ek        =    cdat-temD*afa_new+temD(:,i)*ai;
% % % SVD的方法更新di (怎么出现个别不收敛现象呢）
% %         [U1, ~, ~]=svd(Ek, 'econ');
% %         di=U1(:,1);
% %         temD_new(:,i)    =    di;
%%最小二乘法更新di
%          di        =    Ek*ai'*inv(ai*ai');
%%%
        di        =    Ek*ai';
        di        =    di./norm(di,2);
        temD_new(:,i)    =    di;
    end
% %      temD_new=cdat*pinv(afa_new);
    D_Mat{ci} = temD_new;
    
    %updata Y1&mu
        Y1=Y1+mu*(S_new-afa_new);
        A1=(sqrt(yital)*norm(afa_new-afa, 'fro'));
        S1=(norm(S_new-S, 'fro'));
        D1=(norm(temD_new-temD, 'fro'));
        matr=[A1 S1 D1];
        Mmax=max(matr);
        if mu*Mmax<=et
            p=p0;
            
        else
            p=1;

        end
        mu=min(mu_max, p*mu);
        
    S=S_new;
    afa=afa_new;
    temD=temD_new; 
    
    zz            =    cdat-temD*afa;
    zalpha        =    afa(:);
    avg_afa       =    repmat(mean(Coef{ci},2),[1 size(Coef{ci},2)]);
    z_afa         =    afa - avg_afa;
    [Uz,Sz,Vz]=svd(afa);
     nuclearnorm=diag(Sz);
    Jnow   =  zz(:)'*zz(:)+lambda1*sum(zalpha(:).*zalpha(:))+lambda2*sum(z_afa(:).*z_afa(:))+sum(nuclearnorm);%判断是否收敛的
%     Jnow         =    sqrt(norm(zz,'fro'))+lambda1*sqrt(norm(zalpha,'fro'))+lambda2*sqrt(norm(z_afa,'fro'))+sum(nuclearnorm);
    J(iteration)=Jnow;
    iteration     =    iteration+1;
    
    end
    J1(ci,:)=J;
    Jmean=mean(J1,1);
%     plot(J,'r-+','Linewidth',2);
%     text1=xlabel('迭代次数','FontSize',13,'Vertical','middle','FontName','宋体');
%     text2=ylabel('函数值','FontSize',13,'Vertical','middle','FontName','宋体');
%     set(text2,'Units','Normalized','Position',[-0.08,0.5,0]);
%     set(text1,'Units','Normalized','Position',[0.5,-0.085,0]);
%     grid
%     set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.8,'LineWidth', 0.8);
%     fprintf('%d\n',Jnow); 
end
    Jmean=mean(Jmean,1);
    plot(Jmean,'r-+','Linewidth',2);
    text1=xlabel('Number of iterations','FontSize',13,'Vertical','middle','FontName','Times new Roman');
    text2=ylabel('Function value','FontSize',13,'Vertical','middle','FontName','Times new Roman');
    set(text2,'Units','Normalized','Position',[-0.08,0.5,0]);
    set(text1,'Units','Normalized','Position',[0.5,-0.085,0]);
    grid
    set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.8,'LineWidth', 0.8);
    fprintf('%d\n',Jnow); 
   

