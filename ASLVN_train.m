clc;
clear all;
close all;


%% Load Data
load('HH_train.mat')

%% ASLVN Model Initilizations
% LVN Structure Parameters /model order
L1 = 4; H1 = 1; Q1 = 2;
L2 = 4; H2 = 2; Q2 = 2;

M = 100; % Memory length
lambda = 0.01; % L1 Regularization strength for LVN

% Simulated Aneealing Related Parameters
SA.Tmpt = 100;
SA.MAX_GLOBAL_ITR = 2000;
SA.MAX_LOCAL_ITR = 5e2;
SA.TOTAL_ITR = SA.MAX_GLOBAL_ITR * SA.MAX_LOCAL_ITR;
SA.COOL_CONST = 0.99;

% Step size
sA1 = 1e-2; sW1 = 1e-2 * ones(L1, H1); sC1 = 1e-1 * ones(Q1, H1);
sA2 = 1e-2; sW2 = 1e-2 * ones(L2, H2); sC2 = 1e-1 * ones(Q2, H2);
sCx = 1e-1 * ones(H1, H2); sY0 = 1e-2;

% Inputs for ASLVN
x = x_train;
y = y_train;

x1 = x;
x2 = y;
Ndelay = 1;
x2 = [zeros(Ndelay, 1); x2];
x2(length(x)+1:end) = [];
theta = 4.5; % Threshold for autoregressive branch
x2(x2<theta) = 0;


%% Simulated Annealing with Parallization
N_parallel = feature('numcores'); % No. of paramllization units, cannot exceed the no. of CPU cores
spmd(N_parallel)
    subLVN1 = buildSubLVN(x1, Q1, L1, H1, sA1, sW1, sC1);
    subLVN2 = buildSubLVN(x2, Q2, L2, H2, sA2, sW2, sC2);
    subLVN_all = [subLVN1, subLVN2];
    Ni = length(subLVN_all);
    LVN = integrateSubLVN(subLVN_all, y, fs, sCx, sY0, M, lambda);
    
    % Moniter important parameters
    SA.MAX_MON_ITR = 1e4;
    if SA.TOTAL_ITR <= SA.MAX_MON_ITR
        SA.MON_ITR = SA.TOTAL_ITR;
        SA.SHRINK_SIZE = 1;
    else
        SA.MON_ITR = SA.MAX_MON_ITR;
        SA.SHRINK_SIZE = SA.TOTAL_ITR / SA.MAX_MON_ITR;
    end
    monitor.A = zeros(Ni, SA.MON_ITR);
    monitor.nmse = zeros(1, SA.MON_ITR);
    monitor.cost = zeros(1, SA.MON_ITR);
    monitor.Y0 = zeros(1, SA.MON_ITR);
    
    for j = 1:Ni
        monitor.(['W', LVN.name(j)]) = zeros(LVN.L(j), LVN.H(j), SA.MON_ITR);
        monitor.(['C', LVN.name(j)]) = zeros(LVN.Q(j), LVN.H(j), SA.MON_ITR);
    end
    
    %% Simulated Annealing
    LVN = forwardProp(LVN);
    for global_itr = 1:SA.MAX_GLOBAL_ITR
        SA.Tmpt = SA.Tmpt * SA.COOL_CONST;
        for local_itr = 1:SA.MAX_LOCAL_ITR
            i = local_itr + (global_itr - 1) * SA.MAX_LOCAL_ITR;
            
            % Propose New Parameters values and compute new nmse
            newLVN = getNewParamVals(LVN, subLVN_all);
            newLVN = forwardProp(newLVN);
            
            % Update by Metropolis acceptance algorithm
            cost = LVN.cost;
            new_cost = newLVN.cost;
            if new_cost < cost
                p = 1;
            else
                p = exp((cost - new_cost)/SA.Tmpt);
            end
            Update = rand(1) <= p;
            if Update == 1
                LVN = newLVN;
            end
            
            % Monitor Values
            if mod(i, SA.SHRINK_SIZE) == 0
                im = floor(i / SA.SHRINK_SIZE);
                monitor.A(:, im) = LVN.A;
                monitor.nmse(im) = LVN.nmse;
                monitor.cost(im) = LVN.cost;
                monitor.Y0(im) = LVN.Y0;
                for j = 1:Ni
                    monitor.(['W', LVN.name(j)])(:, :, im) = LVN.(['W', LVN.name(j)]);
                    monitor.(['C', LVN.name(j)])(:, :, im) = LVN.(['C', LVN.name(j)]);
                end
                monitor.Cx(:, im) = LVN.Cx;
            end
        end
    end
end

%% Collect the best results from all the parallel branches
for i = 1:length(LVN)
    tmp = LVN{i};
    nmse(i) = tmp.nmse;
    cost_all(i) = tmp.cost;
end
[~, idx] = min(cost_all);
LVN = LVN{idx};
monitor = monitor{idx};
SA = SA{idx};

%% Plot and Display the results
% Plot the monitor parameters
plotParams(LVN, monitor, SA)

% Plot PDMs
LVN = plotPDMs(LVN);

% Plot PAFs
plotPAFs(LVN)

% Plot kernels
LVN = plotKernels(LVN);

% Show comparison results
showResults(LVN)

% Plot PAF output
plotZ(LVN)

% Save results
save ASLVN_training_results.mat LVN monitor SA
