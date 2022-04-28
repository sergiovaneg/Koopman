%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
data_source = "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/";

%% Parameters

Ts = 1e-2;
Tf = 20;
M = 30;
alpha = 0;
load(data_source + sprintf("Radial/Operator_M_%i_alpha_%i",M,alpha), ...
    "X0","A","B");

nx = 2;
ny = 2;
nu = 1;
nlobj = nlmpc(nx,ny,nu);

nlobj.Ts = Ts;
nlobj.PredictionHorizon = 25;
nlobj.ControlHorizon = 5;

nlobj.ManipulatedVariables.Max = 1.;
nlobj.ManipulatedVariables.Min = -1.;

nlobj.OutputVariables(2).Max = 2;
nlobj.OutputVariables(2).Min = -2;

nlobj.Model.StateFcn = "koopman_vdp";
nlobj.Model.IsContinuousTime = false;
nlobj.Model.NumberOfParameters = 3;
nlobj.Model.OutputFcn = @(x,u,X0,A,B) x;
nlobj.Weights.OutputVariables = [1. .1];

createParameterBus(nlobj, ...
    ['Simulink_VDP_Koopman' '/koopmanMPC'], ...
    'param_bus',{X0,A,B});

%% Reference Import

data_source = "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/";
data_files = dir(data_source + "*.mat");
load(data_source+data_files(69).name,"z");
Z = z(:,2:end);
R1 = array2timetable(Z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(Z(2,:)',"TimeStep",seconds(Ts));