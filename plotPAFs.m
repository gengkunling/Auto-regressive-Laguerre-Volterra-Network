function plotPAFs(LVN)
Ni = LVN.Ni;
colors = [0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0;0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0];
for i = 1:Ni
    eval(['W = LVN.W', LVN.name(i), ';']);
    eval(['C = LVN.C', LVN.name(i), ';']);
    eval(['V = LVN.V', LVN.name(i), ';']);
    U = V * W;
    H = LVN.H(i);
    Q = LVN.Q(i);
    if i == 1
        Ui1 = U;
    elseif i ==2
        Ui2 = U;
    end
    
    figure
    for h = 1:H
        u_mean = mean(U(:, h));
        u_std = std(U(:, h));
        low = u_mean - u_std;
        up = u_mean + u_std;
        u = low:1e-4:up;
        len = length(u);
        y_ANF = zeros(1, len);
        c = C(:, h);
        for q = 1:Q
            y_ANF = y_ANF + c(q)*u.^q;
        end
        set(gca, 'ColorOrder', colors(h,:));
        plot(u, y_ANF, 'linewidth', 2);
        hold on
    end
    if Ni == 1
        title('Polynomial Activation Functions', 'fontsize', 14);
    else
        title(['Polynomial Activation Functions for input', int2str(i)], 'fontsize', 14);
    end
    legend('PAF1', 'PAF2', 'PAF3', 'PAF4', 'PAF5', 'PAF6','PAF7', 'PAF8', 'PAF9', 'location', 'southeast' );
end
% 
% H = LVN.H;
% Nd = LVN.Nd;
% Ucx1 = zeros(Nd, H(1)*H(2));
% for hh = 1:H(1)
%     idx = 1+ (hh-1)*H(2) : hh*H(2);
%     Ucx1(:, idx) = repmat(Ui1(:, hh), 1, H(2));
% end
% Ucx2 = repmat(Ui2, 1, H(1));
% Cx = repmat(LVN.Cx, Nd, 1);
% uu_cx = Ucx1 .* Ucx2;
% for i = 1:2
%     y_cx = [];
%     uu = uu_cx(:, i);
%     u_mean = mean(uu);
%     u_std = std(uu);
%     low = u_mean - u_std;
%     up = u_mean + u_std;
%     u = low:1e-4:up;
%     y_cx = u*LVN.Cx(i);
%     figure
%     plot(u, y_cx, 'linewidth', 3);
%     ylabel(['cx', int2str(i)]);
% end