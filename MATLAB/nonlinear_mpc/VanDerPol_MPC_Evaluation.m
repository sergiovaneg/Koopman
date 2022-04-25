%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Operators' retrieval

% Load nlMPC
load(data_source+"vdp_mpc_balanced.mat");

% load Koopman
M = 20;
load(sprintf(data_source+'koopman_balanced_differential_M_%i.mat',M));

%% Set simulation parameters

Tf = 20;
load(sprintf( ...
    "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/Data_%i.mat",93));
R1 = array2timetable(z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(z(2,:)',"TimeStep",seconds(Ts));

createParameterBus(nlobj, ...
    ['Simulink_VDP_comparison' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

y_0 = 0;
ss_0 = Spline_Radial_Obs(y_0,X0);