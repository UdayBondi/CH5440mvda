clear all;
close all;
more off;

load Inorfull;

A = [];
for i = 1:5:130
  A = [A; mean(DATA(i:i+4, :))];
end

%A = DATA(1:5:end, :);
C = CONC(1:5:end, :);

stdE = [];
for i = 1:5:130
  stdE = [stdE; std(DATA(i:i+4, :))];
end

std_mean = mean(stdE);
A = A ./ std_mean;

%A = A ./ stdE;

rmse_min = [];
ss = [];

for j = 1:25
  rmse = [];
  for i = 1:26
    a = A(setdiff(1:26, i), :);
    c = C(setdiff(1:26, i), :);
  
    [u s v] = svd(a);
    
    ss = [ss diag(s)];
    w = v(:, 1:j);
    T = a * w;
    B = inv(T' * T) * T' * c;
  
    aa = A(i, :);
    cc = C(i, :);
    tt = aa * w;
    cc_pred = tt * B;
  
    e = cc - cc_pred;
    rmse = [rmse; sqrt(meansq(e))];
  end

  [min_val min_index] = min(rmse);

%  disp(j)
%  disp(min_val);
%  disp(min_index);
%  disp("----------------");
  rmse_min = [rmse_min; j min_val min_index];
end