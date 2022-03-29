%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/VanDerPol_Unsteady_Input/";

%% Oscillator

ts = 1e-2;
T = 20;
N_Sim = 100;

u_t = 0:ts:T;
sigma = 1; % 0 for constant input
mu = 0;

system("mkdir -p "+Data_Source);
delete(Data_Source+"Data_*.mat");

parfor f=1:N_Sim
    mu = randn(1); % 0 for zero-mean noise
    u = sigma^2*randn(size(u_t)) + mu;
    z0 = 4*rand(2,1) - 2;
    [~,z] = ode113(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
    
    z = z';
    L = length(z)-1;
    parsave(sprintf(Data_Source+'Data_%i.mat',f),L,z,u,T,ts);
end
