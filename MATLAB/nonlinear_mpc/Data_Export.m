%% Env Init

close all;
clc;

%% Directory Selection

data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Data extraction

X = out.X_hat';
Y = out.Y';
U = [out.U_ref';out.U_vdp'];
save(data_source + "data_kalman_definitive.mat","U","X","Y","Ts","out");