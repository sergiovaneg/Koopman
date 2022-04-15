%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/VanDerPol_Noisy_Unsteady_Input/Radial/";

%% Operator retrieval

alpha = 3;
load(sprintf(Data_Source+'Operator_M_30_alpha_%i.mat',alpha));

VanDerPol = ss(A,B,C,D,ts);
% step(VanDerPol);
VanDerPol = setmpcsignals(VanDerPol,'MV',1,'MO',2,'UO',1);

mpcobj = mpc(VanDerPol,ts);
mpcobj.PredictionHorizon = 25;
% review(mpcobj);
mpcobj.MV.Min = -10;
mpcobj.MV.Max = 10;

r = [0 1];
T = 1e5;
sim(mpcobj,T,r);