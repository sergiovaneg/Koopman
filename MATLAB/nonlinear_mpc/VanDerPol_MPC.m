%% Env Init

close all;
clearvars;
clc;

%% Parameters

Ts = 1e-2;
eta = 0.001;

nx = 2;
ny = 2;
nu = 1;
nlobj = nlmpc(nx,ny,nu);

nlobj.Ts = Ts;
nlobj.PredictionHorizon = 25;
nlobj.ControlHorizon = 5;

nlobj.MV.Max = 2;
nlobj.MV.Min = -2;
nlobj.OV(2).Max = 1;
nlobj.OV(2).Min = -1;

nlobj.Model.StateFcn = "vdp_DT0";
nlobj.Model.IsContinuousTime = false;
nlobj.Model.NumberOfParameters = 1;
nlobj.Model.OutputFcn = @(x,u,Ts) x;
nlobj.Weights.OutputVariables = [1. .0];
    
% x0 = rand(ny,1)*2-1;
% u0 = 1;
% validateFcns(nlobj,x0,u0,[],{Ts});

save("~/Documents/Thesis/Nonlinear_MPC_VDP/vdp_mpc_definitive","nlobj","Ts");
    
createParameterBus(nlobj, ...
    ['Simulink_VDP_KalmanMPC' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

%% Reference Import

% data_source = "~/Documents/Thesis/VanDerPol_Clean_Unsteady_Input/";
% data_files = dir(data_source + "*.mat");
% load(data_source+data_files(1).name,"z");
% Z = z(:,2:end);
% for i=2:length(data_files)
%     load(data_source+data_files(i).name,"z");
%     Z = [Z z(:,2:end)];
% end
% R1 = array2timetable(Z(1,:)',"TimeStep",seconds(Ts));
% R2 = array2timetable(Z(2,:)',"TimeStep",seconds(Ts));

%% Reference Generation

refs = -1:0.1:1;
step_length = 5;
last = 0;
Z = zeros(2,3*length(refs)*step_length/Ts);
idx = 1;

for i=1:length(refs)
    Z(1,idx:idx+step_length/Ts-1) = refs(i);
    Z(2,idx) = (refs(i)-last)/(2*Ts);
    idx = idx+step_length/Ts;
    last = refs(i);
end
for i=length(refs):-1:1
    Z(1,idx:idx+step_length/Ts-1) = refs(i);
    Z(2,idx) = (refs(i)-last)/(2*Ts);
    idx = idx+step_length/Ts;
    last = refs(i);
end

ref_order = randperm(length(refs));
for i=1:length(refs)
    Z(1,idx:idx+step_length/Ts-1) = refs(ref_order(i));
    Z(2,idx) = (refs(ref_order(i))-last)/(2*Ts);
    idx = idx+step_length/Ts;
    last = refs(ref_order(i));
end

R1 = array2timetable(Z(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(Z(2,:)',"TimeStep",seconds(Ts));
Tf = size(Z,2)*Ts;