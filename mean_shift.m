function [X] = mean_shift(X)
%Use this fuction to mean shift the data
%   X is NXP, the mean of the columns is calculated and subtracted from X
    X=X-mean(X);
end

