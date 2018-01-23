
function [x_sample, y_sample, fs] = HH_equation(Ttotal)

% H-H related parameters
g_K = 36;
g_Na = 120;
g_L = 0.3;

E_K = -12;
E_Na = 115;
E_L = 10.6;
Cm = 1;

% Calculate the initial values for n,m,h
V0 = 0;
alpha_n0 = -0.01*(V0-10)./(exp(-(V0-10)./10)-1);
beta_n0 = 0.125*exp(-V0./80);
n0 = alpha_n0./(alpha_n0+beta_n0);

alpha_m0 = -0.1*(V0-25)./(exp(-(V0-25)./10)-1);
beta_m0 = 4*exp(-V0./18);
m0 = alpha_m0./(alpha_m0+beta_m0);

alpha_h0 = 0.07*exp(-V0./20);
beta_h0 = 1./(exp(-(V0-30)./10)+1);
h0 = alpha_h0./(alpha_h0+beta_h0);

% For the Time period of 0-1ms wiht V0 = 0 mV
delta = 1e-3;
t1 = 0:100*delta:1;
I_K0 = n0.^4*g_K.*(V0-E_K);
I_Na0 = m0.^3.*h0.*g_Na*(V0-E_Na);
I_L0 = g_L*(V0-E_L);
I_m0 = I_K0+I_Na0+I_L0;
V(1:size(t1)) = V0;

Ntotal = Ttotal / delta; 

% Injected current for H-H equation, pulse train with frequency fs and
% lasting time T_Ij
f = 200; % Frequency of inject current 
T_Ij = 0.5; % Injection lasting time in unit ms
Ij = zeros(Ntotal, 1) + I_m0;
s = 50; % standard deviation of injection current, in unit nA
i = 1e6/f;
idx = [];
while i < Ntotal - 1e6/f
idx = i:i+T_Ij*1000;
Ij(idx) = Ij(idx) + s*randn(1);
i = i + 1e6/f;
end
t = (1:Ntotal)*delta;


% Initilization of intermediate parameters
Ntotal = length(t);
V = zeros(1,Ntotal);
I_K = zeros(1,Ntotal);
I_Na = zeros(1,Ntotal);
I_L = zeros(1,Ntotal);
n = zeros(1,Ntotal);
m = zeros(1,Ntotal);
h = zeros(1,Ntotal);
Im = zeros(1,Ntotal);


V(1) = V0;
n(1) = n0;
m(1) = m0;
h(1) = h0;


% Running forward Euler loop 
for k = 1:Ntotal-1
    alpha_n = -0.01*(V(k)-10)./(exp(-(V(k)-10)./10)-1);
    beta_n = 0.125*exp(-V(k)./80);
    alpha_m = -0.1*(V(k)-25)./(exp(-(V(k)-25)./10)-1);
    beta_m = 4*exp(-V(k)./18);
    alpha_h = 0.07*exp(-V(k)./20);
    beta_h = 1./(exp(-(V(k)-30)./10)+1);
    
    n(k+1) = n(k)+delta*(alpha_n*(1-n(k))-beta_n*n(k));
    m(k+1) = m(k)+delta*(alpha_m*(1-m(k))-beta_m*m(k));
    h(k+1) = h(k)+delta*(alpha_h*(1-h(k))-beta_h*h(k));
    
    I_K(k) = n(k).^4*g_K.*(V(k)-E_K);
    I_Na(k) = m(k).^3.*h(k).*g_Na*(V(k)-E_Na);
    I_L(k) = g_L*(V(k)-E_L);
    
    V(k+1) = V(k)+delta/Cm*(Ij(k)-I_K(k)-I_Na(k)-I_L(k));
end


% Collect the input and output
x = (Ij);
y = V(:);


% Sampling the intput and output data
interval = 250; % sampling interval
sample_idx = (interval:interval:Ntotal);
x_sample = x(sample_idx);
y_sample = y(sample_idx);
N_sample = length(x_sample);

fs = 1 / (Ntotal/N_sample * delta * 1e-3);

















