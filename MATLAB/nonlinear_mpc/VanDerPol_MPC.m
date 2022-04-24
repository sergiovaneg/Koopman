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
nlobj.Weights.OutputVariables = [0.1 1.];
    
x0 = rand(ny,1)*2-1;
u0 = 1;
validateFcns(nlobj,x0,u0,[],{Ts});

createParameterBus(nlobj, ...
    ['Simulink_VDP_nonlinear' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

%% Reference Import

data_source = "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/";
data_files = dir(data_source + "*.mat");
load(data_source+data_files(1).name,"z");
Z = z(:,2:end);
for i=2:length(data_files)
    Z = [Z z(:,2:end)];
end
R1 = array2timetable(Z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(Z(2,:)',"TimeStep",seconds(Ts));