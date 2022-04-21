%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/VanDerPol_Noisy_Unsteady_Input/Radial/";

%% Operator retrieval

alpha = 2;
load(sprintf(Data_Source+'Operator_M_30_alpha_%i.mat',alpha));

VanDerPol = ss(A,B,eye(size(A)),zeros(size(B)),ts);
% step(VanDerPol);
% VanDerPol = setmpcsignals(VanDerPol,'MO',2,'UO',[1,3:length(A)]);

mpcobj = mpc(VanDerPol,ts,10);
ovw = zeros(size(A,1),1); ovw(2) = 1;
mpcobj.Weights.OutputVariables = ovw;
% review(mpcobj);
% mpcobj.MV.Min = -10;
% mpcobj.MV.Max = 10;

% r = [0 1];
% T = 1e5;
% sim(mpcobj,T,r);