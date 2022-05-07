%% Env Init

close all;
clc;

%% Directory Selection

data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Data extraction

X = [out.X';out.Z'];
U = [out.U_ref';out.U_vdp'];
U_hat = out.U_hat';
save(data_source + "data_kalman_definitive.mat","U","X","Ts","U_hat","out");