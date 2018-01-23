function LVN = plotKernels(LVN)

Ni = LVN.Ni;

for i = 1:Ni
    eval(['W = LVN.W', int2str(i), ';']);
    eval(['C = LVN.C', int2str(i), ';']);
    eval(['PDMs = LVN.PDM', int2str(i), ';']);
    M = length(PDMs);
    H = LVN.H(i);
    
    K1 = zeros (M, 1);
    for m = 1:M
        for h = 1:H
            K1(m) = K1(m) + C(1, h) * PDMs(m, h);
        end
    end
    
    eval(['LVN.K', int2str(i), '1 = K1;']);
    
    
    if LVN.Q(i) == 1
        figure
        plot(K1, 'linewidth', 2);
        xlabel('m');
        ylabel('k1');
        if Ni == 1
            title('First Order Kernel Estimated by LVN', 'fontsize', 14);
        else
            title(['First Order Kernel Estimation for input ', int2str(i)], 'fontsize', 14);
        end
        
    else
        K2 = zeros (M, M);
        for m1 = 1:M
            for m2 = 1:M
                for h = 1:H
                    K2(m1, m2) = K2(m1, m2) + C(2, h) * PDMs(m1, h) * PDMs(m2, h);
                end
            end
        end
        eval(['LVN.K', int2str(i), '2 = K2;']);
        
        figure
        subplot(211)
        plot(K1, 'linewidth', 2);
        xlabel('m');
        ylabel('k1');
        if Ni == 1
            title('First Order Kernel Estimated by LVN', 'fontsize', 14);
        else
            title(['First Order Kernel Estimation for input ', int2str(i)], 'fontsize', 14);
        end
        
        subplot(212)
        mesh(K2);
        xlabel('m2'); ylabel('m1'); zlabel('k2');
        if Ni == 1
            title('Second Order Kernel Estimated by LVN', 'fontsize', 14);
        else
            title(['Second Order Kernel Estimation for input ', int2str(i)], 'fontsize', 14);
        end
    end
    
end

PDM1 = LVN.PDM1;
PDM2 = LVN.PDM2;
Cx = LVN.Cx;
M1 = length(PDM1);
M2 = length(PDM2);
Kx = zeros(M1, M2);
for m1 = 1:M1
    for m2 = 1:M2
        i = 1;
        for h1 = 1:LVN.H(1)
            for h2 = 1:LVN.H(2)
                Kx(m1, m2) = Kx(m1, m2) + Cx(i)*PDM1(m1, h1)*PDM2(m2, h2);
                i = i + 1;
            end
        end
    end
end
figure
mesh(Kx);
xlabel('m2'); ylabel('m1'); zlabel('kcx');
title('Cross Kernels')

