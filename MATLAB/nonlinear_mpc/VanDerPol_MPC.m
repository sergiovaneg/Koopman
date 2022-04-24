%% Env Init

close all;
clearvars;
clc;

%% Parameters

Ts = 1e-2;
Tf = 2000;

nx = 2;
ny = 2;
nu = 1;
nlobj = nlmpc(nx,ny,nu);

nlobj.Ts = Ts;
nlobj.PredictionHorizon = 25;
nlobj.ControlHorizon = 5;

% nlobj.ManipulatedVariables.Max = 5.;
% nlobj.ManipulatedVariables.Min = -5.;

nlobj.Model.StateFcn = "vdp_DT0";
nlobj.Model.IsContinuousTime = false;
nlobj.Model.NumberOfParameters = 1;
nlobj.Model.OutputFcn = @(x,u,Ts) x;
nlobj.Weights.OutputVariables = [0. 1.];
    
x0 = [1;1];
u0 = 1;
validateFcns(nlobj,x0,u0,[],{Ts});

createParameterBus(nlobj, ...
    ['Simulink_VDP_nonlinear' '/vdpMPC'], ...
    'Ts_Bus',{Ts});