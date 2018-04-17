clear all
load Inorfull.mat

% N=1000 p= 5
%F is NXp matrix
[nsamples nvar]=size(DATA);

% mean_F=mean(DATA);
% %  Mean Shifting F_meas
% Fmeas= Fmeas-mean_F;

Fmeas=DATA;

SZ = Fmeas'*Fmeas/nsamples; 
%scale_factor = sqrt(diag(SZ));
% scale_factor = sqrt(nsamples*diag(Qe));
% scale_factor = [10 5 20 15 1];
scale_factor = sqrt(nsamples)*ones(1,nvar);
% scale_factor = sqrt(nsamples)*std;

flag = 1;
nfact = 3;
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
eststd=eststd';

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




