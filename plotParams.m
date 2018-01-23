function plotParams(LVN, monitor, SA)
Ni = LVN.Ni;
M = LVN.M;

%% Plot the actual inputs and outputs, predicted outputs
Nsubfig = Ni + 1;
figure
t = (1:LVN.Nd)*1000 / LVN.fs;
t0 = M*1000 / LVN.fs;
for i = 1:Ni
    x = LVN.x(:, i);
    subplot(Nsubfig, 1, i)
    plot(t, x, 'linewidth', 2);
    if Ni == 1
        tmpt = 'x';
    else
        tmpt = ['x', num2str(i)];
    end
    ylabel(tmpt, 'fontsize', 12);
    xlim([t0, t(end)]);
end
subplot(Nsubfig, 1, Nsubfig)
plot(t, LVN.y, 'linewidth', 2)
ylabel('y', 'fontsize', 12)
hold on
plot(t, LVN.ye, '-.', 'linewidth', 2)
ylabel('ye', 'fontsize', 12)
xlim([t0, t(end)]);
xlabel('time (ms)');



%% Plot the NMSE vs. iterations
figure
t = (1: SA.MON_ITR) * SA.SHRINK_SIZE;
plot(t, monitor.nmse, t, monitor.cost, 'linewidth', 2)
xlabel('iteration #'); 
legend('NMSE', 'cost')
ylim([0 max(5*monitor.cost(end), 1)])
disp('--------------------------------------------');

%% Plot the change of Alphas, W and TH Vs. iteration
figure
plot(t, monitor.A, 'linewidth', 2);
ylabel('Alpha');
xlabel('iteration #');
if Ni > 1
    legend('alpha1', 'alpha2', 'alpha3', 'alpha4', 'alpha5', 'alpha6');
end

figure
plot(t, monitor.Y0, 'linewidth', 2);
ylabel('Y0');
xlabel('iteration #');


MON_ITR = SA.MON_ITR;
for i = 1:Ni
    eval(['W = monitor.W', LVN.name(i), ';']);
    figure
    cnt = 1;
    L = LVN.L(i);
    H = LVN.H(i);
    for l = 1:L
        for j = 1:H
            subplot(L, H, cnt)
            plot(t, reshape(W(l, j, :), MON_ITR, 1), 'linewidth', 2);
            cnt = cnt + 1;
        end
    end
    if Ni == 1
        suptitle('W Tracking curves ');
    else
        suptitle(['W tracking curves input #', int2str(i)]);
    end
end


for i = 1:Ni
    eval(['C = monitor.C', LVN.name(i), ';']);
    figure
    cnt = 1;
    Q = LVN.Q(i);
    H = LVN.H(i);
    for l = 1:Q
        for j = 1:H
            subplot(Q, H, cnt)
            plot(t, reshape(C(l, j, :), MON_ITR, 1), 'linewidth', 2);
            cnt = cnt + 1;
        end
    end
    if Ni == 1
        suptitle('C tracking curves');
    else
        suptitle(['C tracking curves for input #', int2str(i)]);
    end
end

figure
for i = 1:LVN.Ncx
    subplot(ceil(LVN.Ncx/2), 2, i);
    plot(t, monitor.Cx(i, :), 'linewidth', 2);
end
suptitle('Cx tracking curves');


