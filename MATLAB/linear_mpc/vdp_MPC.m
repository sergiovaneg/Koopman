%% Env Init

close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Thesis/Linear_MPC/";
external_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Parameter selection

obs_type = "radial";
n_g = 10; % M->P in the case of polynomial bases
mf = matfile(data_source+"scope_data.mat","Writable",true);

%% Operator retrieval

% load Koopman
if strcmp(obs_type,"radial")
    load(sprintf(data_source+'vdp_radial_ng_%i.mat',n_g));
elseif strcmp(obs_type,"polynomial")
    load(sprintf(data_source+'vdp_polynomial_P_%i.mat',n_g));
end

%% MPC creation

% Definition
oscillator = ss(A,B,C,D,Ts);
weights = zeros();
controller = mpc(oscillator,Ts,25,5);

% Weights - MV
controller.Weights.MV = 0;
controller.Weights.ManipulatedVariablesRate = 0;
controller.MV.Max = 5;
controller.MV.Min = -5;

% Weights - OV
controller.Weights.OV = [1 zeros(1,length(A)-1)];
controller.OV(2).Max = 1;
controller.OV(2).Min = -1;

% Initial state
ctrl_0 = mpcstate(controller);
if strcmp(obs_type,"radial")
    ctrl_0.Plant = Spline_Radial_Obs([0;0],X0);
elseif strcmp(obs_type,"polynomial")
    [ctrl_0.Plant,~] = Poly_Obs([0;0],n_g);
end

%% Nonlinear MPC comparison setup

% Load nlMPC
load(external_source+"vdp_mpc_definitive.mat");

% Bus creation
createParameterBus(nlobj, ...
    ['Nonlinear_KalmanMPC' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

%% External reference setup

eta = 0.001;

load(data_source+"Data_joint.mat");
Tf = 1e3;
