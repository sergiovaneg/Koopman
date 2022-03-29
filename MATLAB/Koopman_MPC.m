%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/VanDerPol_Unsteady_Input/";

%% Operator retrieval

M = 150;
load(sprintf(Data_Source+'Operator_M_%i.mat',M));

VanDerPol = ss(A,B,C,D,ts);
step(VanDerPol);

predHorizon = 10;
ctrlHorizon = 2;
mpcobj = mpc(VanDerPol,ts,predHorizon,ctrlHorizon);

r = [0 1;0 1];
T = 100;
sim(mpcobj,T,r);