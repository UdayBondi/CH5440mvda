clear all
load Inorfull.mat

for i=0:25
    std_est(i+1,:)=std(DATA(i*5+1:i*5+5,:));
end
std_est=mean(std_est);
% 
% for i=1:(size(DATA,1)/5)
%     if(i==1)
%         Xtest(i,:)=DATA(((i-1)*5)+1,:);
%         Ytest(i,:)=CONC(((i-1)*5)+1,:);
%     else
%          Xtest(i,:)=DATA((i-1)*5,:);
%          Ytest(i,:)=CONC((i-1)*5,:);
%     end
%    
% end
for i=0:25
    DATA_av(i+1,:)=mean(DATA(i*5+1:i*5+5,:));
    CONC_av(i+1,:)=mean(CONC(i*5+1:i*5+5,:));
end
DATA=DATA_av;
CONC=CONC_av;
% Mean shifting and autoscaling Z
% Z=mean_shift(DATA);
Z=DATA;
%[Zs,Lz]=auto_scale(Z);
%Zs=Z/diag(mean(stdDATA));
Zs=(Z/diag(std_est))/sqrt(26);

% Sz=Zs'*Zs;
% [V,D]=eig(Sz);
% eigen_values=sort(diag(D));

[u s v]=svd(Zs);
eig_values=round(diag(s).^2,3);
V=v';

for i=1:25
    for j=1:26
        v_truncated=V(:,1:i);
        T=Zs*v_truncated;
        tempx=T;
        tempx(j,:)=[];
        X=tempx;
        Ttest=T(j,:);
        %Y=mean_shift(CONC);
        tempy=CONC;
        tempy(j,:)=[];
        Y=tempy;
        Ytest=CONC(j,:);
        Ys=Y;  %No scaling
        %[Ys,Ly]=auto_scale(Y);
        Aest=OLS(Ys,X);
        y_mean=mean(Ys);
        x_mean=mean(X);
        beta0=y_mean-(x_mean*Aest);

        
        %Predicting y using the model
        Ypred=Ttest*Aest+beta0;
        rmse_vec(j)=rms(rms(Ytest-Ypred));
        rmse_t(i)=min(rmse_vec);
    %     rmse=rmse(Ytest,Ypred);
    %     rmse_t(i)=rms(rmse);
    end
    
end
i=1:25;
plot(rmse_t(i)+100);