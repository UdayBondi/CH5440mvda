clear all
load Inorfull.mat

for i=1:(size(DATA,1)/5)
    if(i==1)
        Xtest(i,:)=DATA(((i-1)*5)+1,:);
        Ytest(i,:)=CONC(((i-1)*5)+1,:);
    else
         Xtest(i,:)=DATA((i-1)*5,:);
         Ytest(i,:)=CONC((i-1)*5,:);
    end
   
end
for i=0:25
    DATA_av(i+1,:)=mean(DATA(i*5+1:i*5+5,:));
    CONC_av(i+1,:)=mean(CONC(i*5+1:i*5+5,:));
end
DATA=DATA_av;
CONC=CONC_av;
% Mean shifting and autoscaling Z
Z=mean_shift(DATA);
[Zs,Lz]=auto_scale(Z);
% Zs=Z/diag(mean(stdDATA));

Sz=Zs'*Zs;
[V,D]=eig(Sz);
eigen_values=sort(diag(D));

for i=1:25
    v_truncated=V(:,size(V,2)-i:size(V,2));
    T=Zs*v_truncated;

    Y=mean_shift(CONC);
    [Ys,Ly]=auto_scale(Y);
    Aest=OLS(Ys,T);
    y_mean=mean(CONC);
    x_mean=mean(T);
    beta0=y_mean-(x_mean*Aest);

    Ttest=Xtest*v_truncated;
    %Predicting y using the model
    Ypred=Ttest*Aest+beta0;
    rmse_t(i)=rms(rms(Ytest-Ypred));
%     rmse=rmse(Ytest,Ypred);
%     rmse_t(i)=rms(rmse);
end
i=1:25;
plot(rmse_t(i)+100);


