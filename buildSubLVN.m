function subLVN = buildSubLVN(x, Q, L, H, sA, sW, sC)
% build the structure and intilizations of the parameters  for subLVN
Nd = length(x);                              % data length
subLVN.x = x;                                % input of the subLVN
subLVN.z = zeros(1, Nd);                     % output of the subLVN
subLVN.Q = Q;                                % order of system nonlinearity 
subLVN.L = L;                                % No. of Laguerre basic function
subLVN.H = H;                                % No. of hidden units/PDMs
subLVN.W = -1 + 2 * rand(L, H);              % weight matrix of subLVN
subLVN.C = -1 + 2 * rand(Q, H);              % polynomial coeeficient matrix of subLVN
subLVN.A = 0.7;                              % crtitical parameter alpha
subLVN.V = zeros(Nd, L);                     % outputs of the filter bank
subLVN.sA = sA;                              % step size of updating A
subLVN.sW = sW;                              % step size of updating W
subLVN.sC = sC;                              % step size of updating C

% Calculate all filter bank outputs Vs for different alphas
nA = 1 / sA;
subLVN.V_all = zeros(Nd, L, nA);
for i = 1:nA
    iA = i * sA;
    subLVN.V_all(:, :, i) = getV(iA, L, x);
end
[subLVN.A, idxA]= clampA(subLVN.A, subLVN.sA); 
subLVN.V = subLVN.V_all(:, :, idxA);
end