% 2 independent variables , F3,F5 
clear all
load flowdata2.mat
% N=1000 p= 5
%F is NXp matrix
no_variables=size(Fmeas,2);
nsamples=size(Fmeas,1);

mean_F=mean(Fmeas);
%Mean Shifting F_meas
Fmeas=Fmeas-mean_F;

% SY = zeros(no_variables);
% for j = 1:nsamples
%     SY = SY + Fmeas(j,:)'*Fmeas(j,:);
% end
% meanY = mean(Fmeas);
% covY = (SY - nsamples*meanY'*meanY)/(nsamples-1);
% 
% % Lsinv = eye(no_variables);  % No scaling
% Lsinv = diag(ones(no_variables,1)./sqrt(diag(covY)));
Lsinv=inv(diag(std));
Fmeas = Fmeas*Lsinv/sqrt(nsamples);


% calculating the svd
[u s v]=svds(Fmeas,no_variables);
eig_values=round(diag(s).^2,3);
no_indep_var=2;
for i=no_indep_var+1:no_variables
    Amat(i-no_indep_var,:)=v(:,i)';
end
Amat = Amat*Lsinv;
Amat=round(Amat,3);
% F3 and F5 as independant variables
Atrue_indep=[Atrue(:,3),Atrue(:,5)];
Atrue_dep=[Atrue(:,1),Atrue(:,2),Atrue(:,4)];
Rtrue=-1*inv(Atrue_dep)*Atrue_indep;

Amat_indep=round([Amat(:,3),Amat(:,5)],3);
Amat_dep=round([Amat(:,1),Amat(:,2),Amat(:,4)],3);
Rmat=round(-1*inv(Amat_dep)*Amat_indep,3);
maxdiff=max(max(abs(Rmat-Rtrue)));

% % 1 independent variables , F1
% clear all
% load flowdata2.mat
% % N=1000 p= 5
% %F is NXp matrix
% no_variables=size(Fmeas,2);
% no_variables=size(Fmeas,2);
% nsamples=size(Fmeas,1);
% 
% mean_F=mean(Fmeas);
% %Mean Shifting F_meas
% Fmeas=Fmeas-mean_F;
% 
% % SY = zeros(no_variables);
% % for j = 1:nsamples
% %     SY = SY + Fmeas(j,:)'*Fmeas(j,:);
% % end
% % meanY = mean(Fmeas);
% % covY = (SY - nsamples*meanY'*meanY)/(nsamples-1);
% % 
% % % Lsinv = eye(no_variables);  % No scaling
% % Lsinv = diag(ones(no_variables,1)./sqrt(diag(covY)));
% Lsinv=inv(diag(std));
% Fmeas = Fmeas*Lsinv/sqrt(nsamples);
% 
% % calculating the svd
% [u s v]=svds(Fmeas,no_variables);
% eig_values=round(diag(s).^2,3);
% no_indep_var=1;
% for i=no_indep_var+1:no_variables
%     Amat(i-no_indep_var,:)=v(:,i)';
% end
% Amat=round(Amat,3);
% Amat = Amat*Lsinv;
% % F3 and F5 as independant variables
% Atrue_indep=[Atrue(:,1)];
% Atrue_dep=[Atrue(:,2),Atrue(:,3),Atrue(:,4),Atrue(:,5)];
% Rtrue=-1*inv(Atrue_dep'*Atrue_dep)*Atrue_dep'*Atrue_indep;
% 
% Amat_indep=round([Amat(:,1)],3);
% Amat_dep=round([Amat(:,2),Amat(:,3),Amat(:,4),Amat(:,5)],3);
% Rmat=round(-1*inv(Amat_dep)*Amat_indep,3);
% maxdiff=max(max(abs(Rmat-Rtrue)));

% % % 3 independent variables , F1,F2,F3 
% clear all
% load flowdata2.mat
% % N=1000 p= 5
% %F is NXp matrix
% no_variables=size(Fmeas,2);
% no_variables=size(Fmeas,2);
% nsamples=size(Fmeas,1);
% 
% mean_F=mean(Fmeas);
% %Mean Shifting F_meas
% Fmeas=Fmeas-mean_F;
% 
% % SY = zeros(no_variables);
% % for j = 1:nsamples
% %     SY = SY + Fmeas(j,:)'*Fmeas(j,:);
% % end
% % meanY = mean(Fmeas);
% % covY = (SY - nsamples*meanY'*meanY)/(nsamples-1);
% % 
% % % Lsinv = eye(no_variables);  % No scaling
% % Lsinv = diag(ones(no_variables,1)./sqrt(diag(covY)));
% Lsinv=inv(diag(std));
% Fmeas = Fmeas*Lsinv/sqrt(nsamples);
% 
% % calculating the svd
% [u s v]=svds(Fmeas,no_variables);
% eig_values=round(diag(s).^2,3);
% no_indep_var=3;
% for i=no_indep_var+1:no_variables
%     Amat(i-no_indep_var,:)=v(:,i)';
% end
%  Amat = Amat*Lsinv;
% Amat=round(Amat,3);
% % F3 and F5 as independant variables
% Atrue_indep=[Atrue(:,1),Atrue(:,2),Atrue(:,3)];
% Atrue_dep=[Atrue(:,4),Atrue(:,5)];
% Rtrue=-1*inv(Atrue_dep'*Atrue_dep)*Atrue_dep'*Atrue_indep;
% 
% Amat_indep=round([Amat(:,1),Amat(:,2),Amat(:,3)],3);
% Amat_dep=round([Amat(:,4),Amat(:,5)],3);
% Rmat=round(-1*inv(Amat_dep)*Amat_indep,3);
% maxdiff=max(max(abs(Rmat-Rtrue)));