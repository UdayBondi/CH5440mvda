
winequalitywhite=dlmread('winequality-white.csv',';',1,0);
winequalityred=dlmread('winequality-red.csv',';',1,0);

y_red=winequalityred(:,12);
x_red=winequalityred(:,1:11);
y_white=winequalitywhite(:,12);
x_white=winequalitywhite(:,1:11);

y=[y_white(1:3430,:);y_red(1:1120,:)];
x=[x_white(1:3430,:);x_red(1:1120,:)];

corr_x= x'*x;
disp(cond(corr_x));
y_test=[y_white(3430:4898,:);y_red(1120:1599,:)];
x_test=[x_white(3430:4898,:);x_red(1120:1599,:)];

% Mean shifting the data
y_mean=mean(y);
x_mean=(mean(x))';
y=y-y_mean;
for i=1:11
   x(:,i)=x(:,i)-x_mean(i);
end

% Calculating the variance (to scale)
y_var=var(y);
x_var=var(x);

%Scaling the values according to their variances
y_scaled=y/sqrt(y_var);
x_scaled=x;
for i=1:11
   x_scaled(:,i)=x(:,i)/sqrt(x_var(i));
end

%v=pca([x_scaled y_scaled]);
z=[x_scaled,y_scaled];
x_var_mat=x_scaled'*x_scaled;
disp(cond(x_var_mat));
%Calculating beta1 and beta0

tuning_parameter=0;
beta1=(inv((x_scaled'*x_scaled)+(tuning_parameter*eye(11))))*(x_scaled'*y_scaled);


for i=1:11
   x_test_modified(:,i)=(x_test(:,i)-x_mean(i));
   x_test_modified(:,i)=x_test_modified(:,i)/sqrt(x_var(i));
end
y_pred=x_test_modified*beta1;
y_pred=(y_pred*sqrt(y_var))+y_mean;

rmse_vector=y_test-y_pred;
rmse=rms(rmse_vector);

%The TLS solution:

%Covariance matrix
covz=z'*z/(size(z,1)-1);

%Eigen values and vectors
[T,E]=eig(covz);
%The eigen vector corresponding to the smallest eigen value (in this case 1st eigen vector)
no_eigen_vec=1;
% y predicted
y_predt=((T(1:11,no_eigen_vec))'*x_test_modified')/-T(12,no_eigen_vec);
y_predt=y_predt';
y_predt=(y_predt*sqrt(y_var))+y_mean;
%Calculating rmse
rmse_vectort=y_test-y_predt;
rmset=rms(rmse_vectort);
