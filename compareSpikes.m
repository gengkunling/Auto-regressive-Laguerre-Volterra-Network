function [Np, Nz, Np2, Ntp, Nfp, TPR, FPR] = compareSpikes(s1, s2)
% Compare the true spikes s1 with the estimated spikes s2
Nd = length(s1);                                % string length
Np = sum(s1 == 1);                             % number of positives in s1 
Np2 = sum(s2 == 1);                             % number of positives in s2
Nz = sum(s1 == 0);

% treat predicted spike as true postive if the 
% location of predicted spike is within (true location +/- 10 lag)

c = [0, 1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6, 7, -7, 8, -8, 9, -9, 10, -10];
Lp = find(s1 == 1);
% m1 = repmat(Lp, 1, length(c));
m1 = Lp(:, ones(1, length(c)));
% m2 = repmat(c, ones(length(Lp), 1));
m2 = c(ones(1, length(Lp)), :);
m = m1 + m2;
m(m > Nd) = Nd;
m(m < 1) = 1;

[m_unq, im] = sort(m(:));
idx = m_unq == [0; m_unq(1 :  end - 1)];
m_unq(idx) = [];
im(idx) = [];

k = zeros(size(m));
k(im) = s2(m_unq) == 1;
kk = sum(k, 2);

Ntp = sum(kk >= 1);                    % No. of true positives
Nfp = Np2 - Ntp;                       % No. of the false positives

TPR = Ntp / Np;
FPR = Nfp / Nz;








