function LVN = integrateSubLVN(subLVN_all, y, fs, sCx, sY0, M, lambda)
% This funcion integrates all the the subLVNs into wholeLVN
% and intilizations of the parameters in wholeLVN

LVN.Ni = length(subLVN_all);                     % No. of input nodes/subLVNs
LVN.Nd = length(subLVN_all(1).x);                 % No. of input nodes/subLVNs
LVN.fs = fs;
LVN.y = y;
LVN.ye = zeros(LVN.Nd, 1);                        % estimated output
LVN.name = [];

for i = 1:LVN.Ni
    LVN.x(:, i) = subLVN_all(i).x;
    LVN.Q(i) = subLVN_all(i).Q;
    LVN.L(i) = subLVN_all(i).L;
    LVN.H(i) = subLVN_all(i).H;
    LVN.A(i) = subLVN_all(i).A;
    LVN.sA(i) = subLVN_all(i).sA;
    LVN.name = [LVN.name, int2str(i)];
    eval(['LVN.W', LVN.name(i), ' = subLVN_all(i).W;']);
    eval(['LVN.C', LVN.name(i), ' = subLVN_all(i).C;']);
    eval(['LVN.sW', LVN.name(i), ' = subLVN_all(i).sW;']);
    eval(['LVN.sC', LVN.name(i), ' = subLVN_all(i).sC;']);
    eval(['LVN.V', LVN.name(i), ' = subLVN_all(i).V;']);
end

H = LVN.H;
LVN.M = M; 
LVN.lambda = lambda;
LVN.Cx = -1 + 2 * rand(1, H(1)*H(2)); 
LVN.sCx = sCx;
LVN.Y0 = 0;
LVN.sY0 = sY0;

% Calculate No. of W, C
Nw = 0; Nc = 0; 
for i = 1: LVN.Ni;
Nw = Nw + LVN.H(i)*LVN.L(i);
Nc = Nc + LVN.H(i)*LVN.Q(i);
end
LVN.Nw = Nw;                                            
LVN.Nc = Nc;                                            
LVN.Ncx = prod(H);
LVN.Nparam =  LVN.Ni + Nw + Nc + +LVN.Ncx + 1;          % No. of all parameters
