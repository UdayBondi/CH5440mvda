clear all
load Inorfull.mat
[maxCo ICo]=max(PureCo);
[maxCr ICr]=max(PureCr);
[maxNi INi]=max(PureNi);
lambda_max=[ICo ICr INi];

X=[DATA(:,lambda_max(1)),DATA(:,lambda_max(2)),DATA(:,lambda_max(3))];
for i=1:(size(DATA,1)/5)
    if(i==1)
        Xtest(i,:)=X(((i-1)*5)+1,:);
        Ytest(i,:)=CONC(((i-1)*5)+1,:);
    else
         Xtest(i,:)=X((i-1)*5,:);
         Ytest(i,:)=CONC((i-1)*5,:);
    end
   
end

%Constructing an OLS model
Xs=mean_shift(X);
%[Xs,Lx]=auto_scale(Xs);
scaling_factor=[mean(stdDATA(:,lambda_max(1))),mean(stdDATA(:,lambda_max(2))),mean(stdDATA(:,lambda_max(3)))];
Xs=(Xs/diag(scaling_factor))/sqrt(size(DATA,1));
Y=mean_shift(CONC);
[Ys,Ly]=auto_scale(Y);
Aest=OLS(Ys,Xs);
y_mean=mean(CONC);
x_mean=mean(X);
beta0=y_mean-(x_mean*Aest);

%Predicting y using the model
Ypred=Xtest*Aest+beta0;
rmse=rmse(Ytest,Ypred);
rmse_t=rms(rmse);