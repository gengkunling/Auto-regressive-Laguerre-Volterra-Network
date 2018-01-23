function LVN = forwardProp(LVN)
y = LVN.y(:);
Ni = LVN.Ni;
Nd = LVN.Nd;
M= LVN.M;
z = zeros(Nd, Ni);
H = LVN.H;
ssC = sum(abs(LVN.Cx));
ssW = 0;

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
    ssC = ssC + sum(abs(C(:)));
    ssW  = ssW + sum(abs(W(:)));
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
LVN.ye = ye;
err = y - ye;
err(1:M) = [];
LVN.nmse = sum (err .* err) / sum(y(M+1:end).^2);
LVN.cost = LVN.nmse + LVN.lambda * (ssC + ssW );


