
% Evaluate the ASLVN performance using the test data set

clc
clear all
close all

% load the test data and ASLVN model
load ASLVN_training_results.mat
load HH_test.mat

W1 = LVN.W1; C1 = LVN.C1; A1 = LVN.A(1); M1 = getM(A1); L1 = size(W1, 1); H1 = size(W1, 2); Q1 = size(C1, 1);
W2 = LVN.W2; C2 = LVN.C2; A2 = LVN.A(2); M2 = getM(A2); L2 = size(W2, 1); H2 = size(W2, 2); Q2 = size(C2, 1);
Cx = LVN.Cx;
M = max(M1, M2);

N_discard = 100;
x1_test = x_test;
N_test = length(y_test);
y_test_pred = zeros(N_test, 1);
y_test_pred(1:N_discard) = y_test(1:N_discard);
x2_test = [0; y_test_pred];
x2_test(end) = [];
x2_test(x2_test<4.5) = 0;

V1 = getV(A1, L1, x1_test);
U1 = V1 * W1;
V2 = getV(A2, L2, x2_test);
V2(N_discard:end, :) = [];
U2 = V2 * W2;
beta = sqrt(A2);

for i = N_discard:N_test
    u1 = U1(i, :);
    x2_test(i) = (y_test_pred(i-1)>4.5)*y_test_pred(i-1);
    V2(i ,1) = beta * V2(i-1, 1) + sqrt(1-A2) * x2_test(i);
    for j = 2:L2
        V2(i, j)= beta * V2(i-1, j) + beta * V2(i, j-1) - V2(i-1, j-1);
    end
    
    v2 = V2(i, :);
    u2 = v2 * W2;
    Ucx1 = zeros(1, H1*H2);
    if i> M
        if LVN.Q(1) == 1
            z1 = u1 * C1(1, :)';
        elseif LVN.Q(1) == 2
            z1 = u1 * C1(1, :)' + u1.^2 * C1(2, :)';
        elseif LVN.Q(1) == 3
            z1 = u1 * C1(1, :)' + u1.^2 * C1(2, :)' + u1.^3 * C1(3, :)';
        else
            error('The Q shoud not exceed 3!');
        end
        if LVN.Q(2) == 1
            z2 = u2 * C2(1, :)';
        elseif LVN.Q(2) == 2
            z2 = u2 * C2(1, :)' + u2.^2 * C2(2, :)';
        elseif LVN.Q(2) == 3
            z2 = u2 * C2(1, :)' + u2.^2 * C2(2, :)' + u2.^3 * C2(3, :)';
        else
            error('The Q shoud not exceed 3!');
        end
        for hh = 1:H1
            idx = 1+ (hh-1)*H2 : hh*H2;
            Ucx1(idx) = repmat(u1(hh), 1, H2);
        end
        Ucx2 = repmat(u2, 1, H1);
        z_cx = sum(Ucx1 .* Ucx2 .* Cx);
        
        y_test_pred(i) = LVN.Y0 + z1 + z2 + z_cx;
    end
end



% Plot the continuous data prediction and NMSE
NMSE_test = sum((y_test_pred - y_test).^2) / sum(y_test.^2)
figure
t_test = [1:length(y_test)]*1000/fs;
plot(t_test, y_test, 'linewidth', 2);
hold on
plot(t_test, y_test_pred, '-.', 'linewidth', 2);
xlabel('time (ms)');
ylabel('Voltage (mV)')
title(['ASLVN, NMSE = ', num2str(NMSE_test)])
legend('Real', 'Predict')
xlim([5000, 6000])
ylim([-60, 120])

% Generate the spike data 
Th = 50;
R = 20;
y_test_spike = spike_gen_HH(y_test, Th, R);
y_test_pred_spike = spike_gen_HH(y_test_pred, Th, R);

t = [1:length(y_test)]/fs*1000; % t in unit of ms


% Plot the binary spike predictions
figure
idx = y_test_spike==1;
stem(t(idx), y_test_spike(idx), 'linewidth', 2, 'marker', '.', 'markersize', 20)
xlim([5000, 6000])
hold on
idx = y_test_pred_spike==1;
stem(t(idx), 0.8*y_test_pred_spike(idx), 'linewidth', 2, 'marker', '.', 'markersize', 20)
xlim([5000, 6000])
legend('Real', 'Predict', 'Location','southeast')
xlabel('Time (ms)', 'fontsize', 14)


format short
[Np, Nz, Np_pred, Ntp, Nfp, TPR, FPR] = compareSpikes(y_test_spike, y_test_pred_spike)

% Plot ROC curve
[Ntp, Nfp] = plot_ROC(y_test_spike, y_test_pred, R);






