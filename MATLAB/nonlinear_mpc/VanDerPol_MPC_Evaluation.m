%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Operators' retrieval

% Load nlMPC
load(data_source+"vdp_mpc_definitive.mat");

% load Koopman
load(data_source+'koopman_definitive_hybrid_M_40.mat');

%% Set simulation parameters

Tf = 20;
load(sprintf( ...
    "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/Data_%i.mat",75));
R1 = array2timetable(z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(z(2,:)',"TimeStep",seconds(Ts));

createParameterBus(nlobj, ...
    ['Simulink_VDP_comparison' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

y_0 = 0;
ss_0 = Spline_Radial_Obs(y_0,X0);