clear all
load Inorfull.mat
load eststd.csv

for i=0:25
    std_est(i+1,:)=std(DATA(i*5+1:i*5+5,:));
end
std_est=mean(std_est);

for i=0:25
    DATA_av(i+1,:)=mean(DATA(i*5+1:i*5+5,:));
    CONC_av(i+1,:)=mean(CONC(i*5+1:i*5+5,:));
end
DATA=DATA_av;
CONC=CONC_av;

Z=DATA;

%Zs=(Z/diag(std_est))/sqrt(26);
Zs=(Z/diag(eststd))/sqrt(26);


[u s v]=svd(Zs);
eig_values=round(diag(s).^2,3);
V=v';

for i=1:10
    for j=1:26
        v_truncated=V(:,1:i);
        T=Zs*v_truncated;
        tempx=T;
        tempx(j,:)=[];
        X=tempx;
        Ttest=T(j,:);
        
        tempy=CONC;
        tempy(j,:)=[];
        Y=tempy;
        Ytest=CONC(j,:);
        Ys=Y;  %No scaling
        
        Aest=OLS(Ys,X);
        y_mean=mean(Ys);
        x_mean=mean(X);
        beta0=y_mean-(x_mean*Aest);

        
        %Predicting y using the model
        Ypred=Ttest*Aest+beta0;
        rmse_vec(j)=rms(rms(Ytest-Ypred));
        rmse_t(i)=min(rmse_vec);
   
    end
    
end
i=1:10;
plot(rmse_t(i));
[M,I]=min(rmse_t)