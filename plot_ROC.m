function [Ntp, Nfp] = plot_ROC(true_spike, pred_continous, R)
i = 1;
for Th = min(pred_continous):0.01:max(pred_continous)
    pred_spike = spike_gen_HH(pred_continous, Th, R);
    [Np, Nz, Np2, Ntp(i), Nfp(i), TPR, FPR] = compareSpikes(true_spike, pred_spike);
    i = i + 1;
end

figure
plot(Nfp, Ntp, 'linewidth', 2)
xlabel('False Positives', 'fontsize', 14)
ylabel('True Positives', 'fontsize', 14)
ylim([0 600])
xlim([0 500])