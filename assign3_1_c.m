clear all
load flowdata2.mat
% N=1000 p= 5
%F is NXp matrix
[nsamples nvar]=size(Fmeas);

mean_F=mean(Fmeas);
%  Mean Shifting F_meas
Fmeas= Fmeas-mean_F;

SZ = Fmeas'*Fmeas/nsamples; 
%scale_factor = sqrt(diag(SZ));
% scale_factor = sqrt(nsamples*diag(Qe));
% scale_factor = [10 5 20 15 1];
%scale_factor = sqrt(nsamples)*ones(1,nvar);
scale_factor = sqrt(nsamples)*std;

flag = 1;
nfact = 1;
sumsing = 0;
iter = 0;
while (flag)
    iter = iter + 1;
    Zs = zeros(nsamples,nvar);
    % Scale the data
    for i = 1:nsamples
        for j = 1:nvar
            Zs(i,j) = Fmeas(i,j)/scale_factor(j);
        end
    end
    % Estimate number of PCs to retain
    [u s v] = svd(Zs,0);
    sdiag = diag(s);
    sumsingnew = sum(sdiag(nfact+1:end));
    %  Obtain constraint matrix in scaled domain
    for k = nfact+1:nvar
        Amat(k-nfact,:) = v(:,k)';
    end
    % Get the constraint matrix in terms of original variables
    for k = 1:nvar
        Amat(:,k) = Amat(:,k)/scale_factor(k);
    end
    if ( abs(sumsingnew -sumsing) <= 0.0001 )
        flag = 0;
    else
        % Estimate covariance matrix (diagonal) and iterate
        eststd = stdest(Amat,Fmeas');
        scale_factor = sqrt(nsamples)*eststd;
        sumsing = sumsingnew;
    end
end

Amat;
spca = diag(s);
eig_values=round(diag(s).^2,3);
% theta_pca = 180*subspace(Atrue', Amat')/pi;
% Determine how well the model matches with the true constraint matrix.
% For this determine the minimum distance of each true constraint vector from the
% row space of model constraints
% for i = 1:3
%     bcol = Atrue(i,:)';
%     dist_pca(i) = norm(bcol - Amat'*inv(Amat*Amat')*Amat*bcol);
% end

% Regression model
% Atrue = [1 -1 0 0 0 0 1 0; 0 1 -1 0 0 0 0 0; 0 0 1 -1 0 0 0 0; 0 0 0 1 -1 -1 0 0; 0 0 0 0 0 1 -1 -1];
% Aind = [Atrue(:,1) Atrue(:,5) Atrue(:,7)];
% Adep = [Atrue(:,2:4) Atrue(:,6) Atrue(:,8)];
% Rtrue = -inv(Adep)*Aind;
% Aindest = [Amat(:,1) Amat(:,5) Amat(:,7)];
% Adepest = [Amat(:,2:4) Amat(:,6) Amat(:,8)];
% Rest = -inv(Adepest)*Aindest;
% maxerr = max(max(abs(Rtrue-Rest)));

Amatdep12 = [Amat(:,3) Amat(:,4) Amat(:,5)];
cond_no12=cond(Amatdep12);

Amatdep13 = [Amat(:,2) Amat(:,4) Amat(:,5)];
cond_no13=cond(Amatdep13);

Amatdep14 = [Amat(:,2) Amat(:,3) Amat(:,5)];
cond_no14=cond(Amatdep14);

Amatdep15 = [Amat(:,2) Amat(:,3) Amat(:,4)];
cond_no15=cond(Amatdep15);

Amatdep23 = [Amat(:,1) Amat(:,4) Amat(:,5)];
cond_no23=cond(Amatdep23);

Amatdep24 = [Amat(:,1) Amat(:,3) Amat(:,5)];
cond_no24=cond(Amatdep24);

Amatdep25 = [Amat(:,1) Amat(:,3) Amat(:,4)];
cond_no25=cond(Amatdep25);

Amatdep34 = [Amat(:,1) Amat(:,2) Amat(:,5)];
cond_no34=cond(Amatdep34);

Amatdep35 = [Amat(:,1) Amat(:,2) Amat(:,4)];
cond_no35=cond(Amatdep35);

Amatdep45 = [Amat(:,1) Amat(:,2) Amat(:,3)];
cond_no45=cond(Amatdep45);

cond_no=[cond_no12;cond_no13;cond_no14;cond_no15;cond_no23;cond_no24;cond_no25;cond_no34;cond_no35;cond_no45];
round(sort(cond_no),3);


