function newLVN = getNewParamVals(LVN, subLVN_all)

Ni = LVN.Ni;
Np = LVN.Nparam;
Nw = LVN.Nw;
Nc = LVN.Nc;
Ncx = LVN.Ncx;
newLVN = LVN;
L = LVN.L;
Q = LVN.Q;
H = LVN.H;


r = rand(1);
tmp = sign(rand(1) - 0.5);

if r <= 2/Np
    update = 'alpha';
elseif r > 2/Np && r <= (2+Nw)/Np
    update = 'w';
elseif r > (2+Nw)/Np && r < (2+Nw+Nc)/Np
    update = 'c';
elseif r >= (2+Nw+Nc)/Np && r <= (2+Nw+Nc+Ncx)/Np
    update = 'cx';
else
    update = 'y0';
end

if strcmp(update, 'alpha')
    %     %     updata A in subLVN #k
    %     k = floor(rand(1)*Ni) + 1;
    %     sA = LVN.sA(k);
    %     newA = LVN.A(k) +  tmp * sA;
    %     [newA, idxA]= clampA(newA, sA);
    %     newLVN.(['V', newLVN.name(k)]) = subLVN_all(k).V_all(:, :, idxA);
    %     newLVN.A(k) = newA;
elseif strcmp(update, 'w')
    % updata W(j) in subLVN #k
    k = floor(rand(1)*Ni) + 1;
    j = floor(rand(1)*L(k)*H(k)) + 1;
    W = LVN.(['W', LVN.name(k)]);
    C = LVN.(['C', LVN.name(k)]);
    sW = LVN.(['sW', LVN.name(k)]);
    newW = W;
    newW(j) = W(j) + tmp * sW(j);
%     [newW, norm_factor] = normalize(newW); % Normalize weights
%     for q = 1:Q(k)
%         newC(q, :) = C(q, :).*(norm_factor).^q;
%     end
%     for kk = 1:length(LVN.Cx)
%         [a, b] = ind2sub([LVN.H(2), LVN.H(1)], kk);
%         if k == 1
%             newLVN.Cx(kk) = LVN.Cx(kk) * norm_factor(b);
%         else
%             newLVN.Cx(kk) = LVN.Cx(kk) * norm_factor(a);
%         end
%     end
    newLVN.(['W', newLVN.name(k)]) = newW;
%     newLVN.(['C', newLVN.name(k)]) = newC;
elseif strcmp(update, 'c')
    % updata C(j) in subLVN #k
    k = floor(rand(1)*Ni) + 1;
    j = floor(rand(1)*Q(k)*H(k)) + 1;
    C = LVN.(['C', LVN.name(k)]);
    sC = LVN.(['sC', LVN.name(k)]);
    newC = C;
    newC(j) = C(j) + tmp * sC(j);
    newLVN.(['C', newLVN.name(k)]) = newC;
elseif strcmp(update, 'cx')
    % updata Cx(k)
    k = floor(rand(1)*prod(H)) + 1;
    Cx = LVN.Cx;
    sCx = LVN.sCx;
    newCx = Cx;
    newCx(k) = Cx(k) + tmp * sCx(k);
    newLVN.Cx = newCx;
else
%     % update Y0
%     newLVN.Y0 = LVN.Y0 + tmp * LVN.sY0;
end

