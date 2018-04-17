function [rmse] = rmse(y_test,y_pred)
%rmse Use this function to calculate the root mean squared error
%   
    rmse_vector=y_test-y_pred;
    rmse=rms(rmse_vector);
end

