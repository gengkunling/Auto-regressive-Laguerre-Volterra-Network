function y_spike = getSpike(y)
N = length(y);
L = 10;
for i = 1:L
y_lsi = [y; zeros(i, 1)];
y_lsi(1:i) = [];
y_ls_all(:, i) = y>y_lsi;
y_rsi = [zeros(i, 1); y];
y_rsi(N+1:end) = [];
y_rs_all(:, i) = y>y_rsi;
end

y_spike = zeros(size(y));
idx = find(prod(y_ls_all, 2).*prod(y_rs_all, 2).*(y>50));
y_spike(idx) = 1;