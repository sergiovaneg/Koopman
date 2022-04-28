%% Env Init

close all;
clc;

%% Directory Selection

data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Data extraction

Z = out.Z';
U = [out.U_ref';out.U_vdp'];
save(data_source + "data_noisy_definitive.mat","U","Z","Ts");