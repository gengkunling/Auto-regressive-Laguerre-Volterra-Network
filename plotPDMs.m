function LVN = plotPDMs(LVN)

fs = LVN.fs;
colors = [0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0; 0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0];

for i = 1:LVN.Ni
    % Get PDMs
    eval(['W = LVN.W', int2str(i), ';']);
    eval(['C = LVN.C', int2str(i), ';']);
    A = LVN.A(i);
    M = getM(A);
    L = size(W, 1);
    H = size(W, 2);
    Q = size(C, 1);
    impulse = zeros(M, 1);
    impulse(1) = 1;
    LB = getV(A, L, impulse);
    LVN_PDM = LB * W;
    
    % Normalization and Polarization of PDMs
     [W, norm_factor] = normalize(W); % Normalize weights
    for q = 1:Q
        C(q, :) = C(q, :).*(norm_factor).^q;
    end
    for kk = 1:length(LVN.Cx)
        [a, b] = ind2sub([LVN.H(2), LVN.H(1)], kk);
        if i == 1
            LVN.Cx(kk) = LVN.Cx(kk) * norm_factor(b);
        else
            LVN.Cx(kk) = LVN.Cx(kk) * norm_factor(a);
        end
    end

    [LVN_PDM, polar_val] = polarize(LVN_PDM);
    
    for h = 1:H
        W(:, h) = W(:, h) * polar_val(h);
        C(1:2:Q, h) = C(1:2:Q, h) * polar_val(h);
    end
    
    for kk = 1:length(LVN.Cx)
        [a, b] = ind2sub([LVN.H(2), LVN.H(1)], kk);
        if i == 1
            LVN.Cx(kk) = LVN.Cx(kk) * polar_val(b);
        else
            LVN.Cx(kk) = LVN.Cx(kk) * polar_val(a);
        end
    end
    
    
    eval(['LVN.W', int2str(i), ' = W;']);
    eval(['LVN.C', int2str(i), ' = C;']);
    eval(['LVN.PDM', int2str(i), ' = LVN_PDM;']);
    %
    % Plot time domain PDMs
    figure
    subplot(211)
    for h = 1:H
        t = (1:M) * 1000 / fs;
        set(gca, 'ColorOrder', colors(h,:));
        plot(t, LVN_PDM(:,h), 'linewidth', 2);
        hold on
    end
    legend('PDM1', 'PDM2', 'PDM3', 'PDM4', 'PDM5', 'PDM6', 'PDM7', 'PDM8', 'PDM9');
    xlabel('time (ms)', 'fontsize', 12);
    
    
    % Plot frequency Domain PDMs
    subplot(212)
    NFFT = 2^nextpow2(M) * 4;
    f = fs / 2 * linspace(0,1,NFFT/2+1);
    
    F_LVN = [];
    F_LVN_mag = [];
    for h = 1:H
        F_LVN(:, h) = fft(LVN_PDM(:, h),NFFT)/M;
        F_LVN_mag(:, h) = abs(F_LVN(1:NFFT/2+1, h));
        set(gca, 'ColorOrder', colors(h,:));
        plot(f, F_LVN_mag(:, h), 'linewidth', 2);
        hold on
    end
    legend('PDM1', 'PDM2', 'PDM3', 'PDM4', 'PDM5', 'PDM6', 'PDM7', 'PDM8', 'PDM9');
    xlabel('frequency (Hz)', 'fontsize', 12);
    if LVN.Ni == 1
        suptitle('PDMs Estimated by Sparse LVN');
    else
        suptitle(['PDMs Estimated by Sparse LVN for Input ', num2str(i)]);
    end
    
%     for h = 1:H
%         figure
%         t = (1:M) * 1000 / fs;
%         plot(t, LVN_PDM(:,h), 'linewidth', 3);
%         xlabel('Time (ms)', 'fontsize', 18)
%         xlim([0, 20])
%         set(gca,'FontSize',18)
%     end
    
        
end




