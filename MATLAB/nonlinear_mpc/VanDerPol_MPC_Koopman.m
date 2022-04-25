%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% First step - System observation

load(data_source + "data_noisy_balanced.mat");

M = 20;
n_u = size(U,1);
X0 = 2*rand(size(Z,1),M)-1;

[G,~] = Spline_Radial_Obs(Z,X0);
Px = G(:,1:end-1);
Py = G(:,2:end);
U = U(1:n_u/2,1:end-1) - U(n_u/2+1:end,1:end-1);

%% Second step - Operator calculation

tic

alpha = 0.;
[A,B] = Koopman(Px,Py,U,alpha);

% Original states recovered by convention
% (the first n observers are the original states)
C = zeros(size(Z,1),size(A,2));
C(1:size(Z,1),1:size(Z,1)) = eye(size(Z,1));

% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

save(sprintf(data_source+'koopman_balanced_differential_M_%i.mat',M), ...
    "A","B","C","D","Ts","X0");

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;