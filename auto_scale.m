function [Xs,Lsinv] = auto_scale(X)
%This function auto scales the data
%   Data is scaled with sample variance
Fmeas=X;
[nsamples nvar]=size(X);
SY = zeros(nvar);
for j = 1:nsamples
    SY = SY + Fmeas(j,:)'*Fmeas(j,:);
end
meanY = mean(Fmeas);
covY = (SY - nsamples*meanY'*meanY)/(nsamples-1);


Lsinv = diag(ones(nvar,1)./sqrt(diag(covY)));  % Scaling by measurement variances

Xs = Fmeas*Lsinv/sqrt(nsamples);
end

