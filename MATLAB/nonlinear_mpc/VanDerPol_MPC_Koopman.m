%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
rng('default');
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% First step - System observation

load(data_source + "data_kalman_definitive.mat");
L = size(Y,2)-1;
n_u = size(U,1);
X = [X;Y];
M = 50;
X0 = zeros(size(X,1),M);
for i=1:size(X0,1)
    X0(i,:) = random('Normal',mean(X(i,:)),std(X(i,:)),1,M);
end

% Kalman-koopman (No delay)
[G,~] = Spline_Radial_Obs(X,X0);
G1 = G(:,1:L);
G2 = G(:,2:L+1);
% U = [U(:,2:L+1);Y(:,1:L)]; % For control as output
U = U(:,2:L+1); % For control as state

%% Second step - Operator calculation

tic

alpha = 1e-3;
[A,B] = Koopman(G1,G2,U,alpha,size(X,1));

% Recover control signal (Control as output)
% [C,D] = Koopman(G2,Y(:,2:L+1),U,alpha,size(Y,1));

% Recover control signal (Control as state)
C = zeros(size(Y,1),size(G1,1));
C(3) = 1;
D = zeros(size(Y,1),size(U,1));

save(sprintf(data_source+'kk_asState_M_%i.mat',M), ...
    "A","B","C","D","Ts","X0","n_u");

toc

Lambda = eig(A(:,1:size(A,1)));
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;