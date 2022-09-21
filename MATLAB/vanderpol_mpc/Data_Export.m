%% Env Init

close all;
clc;

%% Directory Selection

data_source = "~/Documents/Modelway/EKF_MPC_VDP/";

%% Data extraction

X = out.X_hat';
Y = out.U_vdp';
W = out.Y';
% P = out.P';
save(data_source+"data_kalman.mat","W","X","Y","P","Ts","out");