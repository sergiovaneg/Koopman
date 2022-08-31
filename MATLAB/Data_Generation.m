%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/Linear_MPC/";

%% Oscillator

ts = 1e-2;
T = 100;
N_Sim = 1;

u_t = 0:ts:T;
sigma = 1.; % 0 for constant input
eta = 0.01; % 0 for no signal noise
mu = 0;

system("mkdir -p "+Data_Source);
delete(Data_Source+"Data_*.mat");

for f=1:N_Sim
    u = random("Normal",mu,sigma,size(u_t));
    z0 = 2*rand(2,1) - 1;
    [~,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
    
    z = (z + eta*randn(size(z)))';
    L = length(z)-1;
    parsave(sprintf(Data_Source+'Data_%i.mat',f),L,z,u,T,ts);
end
