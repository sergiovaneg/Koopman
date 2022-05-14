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
load(data_source+'kk_asState_M_100.mat');

%% Set simulation parameters

Tf = 10;
eta = 0.001;

load(sprintf( ...
    "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/Data_%i.mat",5));
R1 = array2timetable(z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(z(2,:)',"TimeStep",seconds(Ts));

createParameterBus(nlobj, ...
    ['Simulink_VDP_KalmanMPC' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

x_0 = zeros(size(X0,1),1);
ss_0 = Spline_Radial_Obs(x_0,X0);
u_0 = zeros(n_u,1);

% kalman_0 = Spline_Radial_Obs([0;0],X0_kalman);