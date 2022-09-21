%% Env Init

close all;
clearvars;
clc;
addpath("../");
rng('default');
data_source = "~/Documents/Modelway/EKF_MPC_VDP/";

%% Parameter selection

with_cov = false;
n_g = 20; % M->P in the case of polynomial bases
Ts = 0.01;

%% First step - System observation

load(data_source+"data_kalman.mat");
if with_cov
    X1 = [X(:,1:end-1); P(:,1:end-1)];
    X2 = [X(:,2:end); P(:,2:end)];
else
    X1 = X(:,1:end-1);
    X2 = X(:,2:end);
end
U = [Y(:,2:end); W(:,1:end-1)];

n_x = size(X1,1);
n_y = size(Y,1);
n_u = size(U,1);

X0 = zeros(n_x,n_g);
for i=1:n_x
    X0(i,:) = random('Normal',mean(X2(i,:)),std(X2(i,:)),1,n_g);
end
[G1,~] = Spline_Radial_Obs(X1,X0);
[G2,~] = Spline_Radial_Obs(X2,X0);

%% Second step - Operator calculation

tic

alpha = 0e-4;
[A,B] = Koopman(G1,G2,U,alpha,n_x+n_g);
C = zeros(size(X,1),n_x+n_g); C(1:size(X,1),1:size(X,1)) = eye(size(X,1));
D = zeros(size(X,1),n_u);

if with_cov
    save(sprintf(data_source+'EKF_covradial_ng_%i.mat',n_g), ...
        "A","B","C","D","Ts","X0","n_x","n_y","n_u");
else
    save(sprintf(data_source+'EKF_radial_ng_%i.mat',n_g), ...
        "A","B","C","D","Ts","X0","n_x","n_y","n_u");
end

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;