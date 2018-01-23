function plotZ(LVN)
y = LVN.y(:);
Ni = LVN.Ni;
Nd = LVN.Nd;
M= LVN.M;
z = zeros(Nd, Ni);
H = LVN.H;
colors = [0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0];

for i = 1:Ni
    W = LVN.(['W', LVN.name(i)]);
    C = LVN.(['C', LVN.name(i)]);
    V = LVN.(['V', LVN.name(i)]);
    U = V * W;
    if i == 1
        Ui1 = U;
    elseif i ==2
        Ui2 = U;
    end
    Q = LVN.Q(i);
    if Q == 1
        z(:, i) = U * C';
    elseif Q == 2
        U2 = U .* U;
        z(:, i) = U * C(1, :)' + U2 * C(2, :)';
    elseif Q == 3
        U2 = U .* U;
        U3 = U2 .* U;
        z(:, i) = U * C(1, :)' + U2 * C(2, :)' + U3 * C(3, :)';
    else
        error('The order Q should not exceed 3!');
    end
end

z1 = z(:, 1);
if Q == 1
    z21 = U(:, 1) * C(1);
    z22 = U(:, 2) * C(2);
elseif Q == 2
    U2 = U .* U;
    z21 = U(:, 1) * C(1, 1) + U2(:, 1) * C(2, 1);
    z22 = U(:, 2) * C(1, 2) + U2(:, 2) * C(2, 2);
elseif Q == 3
    U2 = U .* U;
    U3 = U2 .* U;
    z21 = U(:, 1) * C(1, 1) + U2(:, 1) * C(2, 1) + U3(:, 1) * C(3, 1);
    z22 = U(:, 2) * C(1, 2) + U2(:, 2) * C(2, 2) + U3(:, 2) * C(3, 2);
else
    error('The order Q should not exceed 3!');
end


Ucx1 = zeros(Nd, H(1)*H(2));
for hh = 1:H(1)
    idx = 1+ (hh-1)*H(2) : hh*H(2);
    Ucx1(:, idx) = repmat(Ui1(:, hh), 1, H(2));
end
Ucx2 = repmat(Ui2, 1, H(1));
Cx = repmat(LVN.Cx, Nd, 1);
z_cx = Ucx1 .* Ucx2 .* Cx;

ye = LVN.Y0 + sum(z, 2) + sum(z_cx, 2);
t = (1:Nd)/LVN.fs*1000;

figure
% plot(t, y, 'k', 'linewidth', 3);
% hold on
set(gca, 'ColorOrder', colors(1,:));
plot(t, ye, '-', 'linewidth', 3);
hold on
set(gca, 'ColorOrder', colors(2,:));
plot(t, z(:, 1), '-.', 'linewidth', 2);
hold on
set(gca, 'ColorOrder', colors(3,:));
plot(t, z(:, 2), ':', 'linewidth', 2);
hold on
set(gca, 'ColorOrder', colors(4,:));
plot(t, sum(z_cx, 2), '--', 'linewidth', 2);
hold off
legend( 'ye', 'z1', 'z2', 'zx')
xlabel('Time (ms)')
xlim([320, 350])

% figure
% subplot(211)
% plot(t, U2(:, 1), 'r-', 'linewidth', 2)
% hold on 
% set(gca, 'ColorOrder', colors(3,:));
% plot(t, U2(:, 2), '-.', 'linewidth', 2)
% xlim([310, 410])
% legend('u21', 'u22')
% 
% subplot(212)
% set(gca, 'ColorOrder', colors(1,:));
% plot(t, z(:, 2), '-', 'linewidth', 3)
% hold on 
% set(gca, 'ColorOrder', colors(2,:));
% plot(t, z21, '-.', 'linewidth', 2)
% hold on
% set(gca, 'ColorOrder', colors(3,:));
% plot(t, z22, ':', 'linewidth', 2)
% legend('z2', 'z21', 'z22')
% xlabel('Time (ms)')
% xlim([310, 410])
% 
% 
% figure
% subplot(311)
% plot(t, Ui1, 'r-', 'linewidth', 2)
% legend('u1')
% xlim([310, 410])
% subplot(312)
% plot(t, U2(:, 1), 'r-', 'linewidth', 2)
% hold on 
% set(gca, 'ColorOrder', colors(3,:));
% plot(t, U2(:, 2), '-.', 'linewidth', 2)
% xlim([310, 410])
% legend('u21', 'u22')
% 
% subplot(313)
% set(gca, 'ColorOrder', colors(1,:));
% plot(t, sum(z_cx, 2), '-', 'linewidth', 3)
% hold on 
% set(gca, 'ColorOrder', colors(2,:));
% plot(t, z_cx(:, 1), '-.', 'linewidth', 2)
% hold on
% set(gca, 'ColorOrder', colors(3,:));
% plot(t, z_cx(:, 2), ':', 'linewidth', 2)
% legend('zcx', 'zcx1', 'zcx2')
% xlabel('Time (ms)')
% xlim([310, 410])

format short
rms_all = [rms(z1) , rms(z21) , rms(z22) , rms(z_cx(:, 1)) , rms(z_cx(:, 2))]
rms_norm = rms_all ./ sum(rms_all)


