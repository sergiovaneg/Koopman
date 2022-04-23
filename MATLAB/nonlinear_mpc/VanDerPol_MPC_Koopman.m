%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
addpath("~/Koopman/MATLAB/");
Data_Source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% First Step - System observation

load(Data_Source + "data_clean.mat");

M = 10;
X0 = 2*rand(size(Z,1),M)-1;

[G,~] = Spline_Radial_Obs(Z,X0);
Px = G(:,1:end-1);
Py = G(:,2:end);
U = U(:,1:end-1);

%% Second Step - Operator calculation

tic

alpha = 1e-4;
[A,B] = Koopman(Px,Py,U,alpha);

% Original states recovered by convention
% (the first n observers are the original states)
C = zeros(size(Z,1),size(A,2));
C(1:size(Z,1),1:size(Z,1)) = eye(size(Z,1));

% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

save(sprintf(Data_Source+'Operator_clean_M_%i.mat',M), ...
    "A","B","C","D","Ts","X0");

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;