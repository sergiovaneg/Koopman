%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
rng(0,'threefry');
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% First step - System observation

load(data_source + "data_kalman_definitive.mat");
L = 1e5;

M = 50;
n_u = size(U,1);
X0 = 2*rand(size(Z,1),M)-1;
[G,~] = Spline_Radial_Obs(Z,X0);

% Full-State
% Px = G(:,1:L);
% Py = G(:,2:L+1);
% U = [U(:,1:L);
%     U(1:n_u/2,1:L) - U(n_u/2+1:end,1:L)];

% Full-State + Delay
% Px = [G(:,3:L);G(:,2:L-1);G(:,1:L-2)];
% Py = G(:,4:L+1);
% U = [U(:,3:L);
%     U(1:n_u/2,3:L) - U(n_u/2+1:end,3:L)];

% Kalman
% Px = G(:,1:L);
% Py = G(:,2:L+1);
% U = [U(:,1:L);
%     U(1,1:L) - U(3,1:L)];

% Kalman + Delay
Px = [G(:,3:L);G(:,2:L-1);G(:,1:L-2)];
Py = G(:,4:L+1);
U = [U(:,3:L);
    U(1,3:L) - U(3,3:L)];

%% Second step - Operator calculation

tic

alpha = 1e-3;
[A,B] = Koopman(Px,Py,U,alpha,1);

% Original states recovered by convention
% (the first n observers are the original states)
C = zeros(size(Z,1),size(A,2));
C(1:size(Z,1),1:size(Z,1)) = eye(size(Z,1));

% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

save(sprintf(data_source+'koopman_kalman_delayed_M_%i.mat',M), ...
    "A","B","C","D","Ts","X0");

toc

Lambda = eig(A(:,1:size(Z,1)));
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;