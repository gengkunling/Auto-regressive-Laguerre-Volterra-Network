function y_spike = spike_gen_HH(y, Th, R)
% spike_gen is to generate the spike trains from the continous signal
% y is the continous signal 
% Th is the threashold to trigger the spike
% R is the refractory period
N = length(y);
y_spike = zeros(size(y));
Refractory = 0;
counter = 1; 
for i = 1:N
    if counter == R 
        Refractory = 0;
    end
    
    if y(i) >= Th && Refractory == 0
        y_spike(i) = 1;
        Refractory = 1;
        counter = 1;
    else
        counter = counter + 1;
    end
end
