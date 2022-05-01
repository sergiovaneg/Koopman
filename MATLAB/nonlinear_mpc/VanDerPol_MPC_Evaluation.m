%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Operators' retrieval

% Load nlMPC
load(data_source+"vdp_mpc_definitive.mat");

% load Kalman
load(data_source+"kalman_M_50.mat");
A_kalman = A;
B_kalman = B;
X0_kalman = X0;

% load Koopman
load(data_source+'koopman_hybrid_M_25.mat');

%% Set simulation parameters

Tf = 20;
eta = 0.001;

load(sprintf( ...
    "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/Data_%i.mat",70));
R1 = array2timetable(z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(z(2,:)',"TimeStep",seconds(Ts));

createParameterBus(nlobj, ...
    ['Simulink_VDP_KK' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

y_0 = 0;
ss_0 = Spline_Radial_Obs(y_0,X0);
kalman_0 = Spline_Radial_Obs([0;0],X0_kalman);