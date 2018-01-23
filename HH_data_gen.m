clc;
clear all;
close all;

% Generate training data
T_train = 1e4; % time in ms
[x_train, y_train, fs] = HH_equation(T_train);
save HH_train x_train y_train fs

% Plot the training data
figure
N_train = length(x_train);
t_train = [1:N_train] * 1000/fs;
subplot(211)
plot(t_train, x_train, 'linewidth', 1.5)
ylabel('Injected Current (uA)')
subplot(212)
plot(t_train, y_train, 'linewidth', 1.5)
ylabel('V_m (mV)')
xlabel('time (ms)')


% Generate test data
T_test = 1e4; % time in ms
[x_test, y_test, fs] = HH_equation(T_test);
save HH_test x_test y_test fs

% Plot the test data
figure
N_test = length(x_test);
t_test = [1:N_test] * 1000/fs;
subplot(211)
plot(t_test, x_train, 'linewidth', 1.5)
ylabel('Injected Current (uA)')
subplot(212)
plot(t_test, y_train, 'linewidth', 1.5)
ylabel('V_m (mV)')
xlabel('time (ms)')
