%% Env Init

close all;
clc;

%% Directory Selection

Data_Source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Data extraction

Z = out.Z';
U = [out.U_ref';out.U_vdp'];
save(Data_Source + "data_clean.mat","U","Z","Ts");