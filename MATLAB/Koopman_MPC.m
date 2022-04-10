%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/VanDerPol_Noisy_Unsteady_Input/Radial/";

%% Operator retrieval

alpha = 2;
load(sprintf(Data_Source+'Operator_alpha_%i.mat',alpha));

VanDerPol = ss(A,B,C,D,ts);
step(VanDerPol);

mpcobj = mpc(VanDerPol,ts);
mpcobj.PredictionHorizon = 20;
% review(mpcobj);

r = [-1 1;
    0 0];
T = 1e4;
sim(mpcobj,T,r);