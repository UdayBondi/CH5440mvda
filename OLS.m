function [beta] = OLS(Y,X)
%OLS
%Given Y(independent) and X(dependent) returns the beta1
% X is NXP where N is the number of samples and P is the no. of variables
% Y and X are assumed to be mean shifted and scaled 
beta=inv(X'*X)*(X'*Y);

end

