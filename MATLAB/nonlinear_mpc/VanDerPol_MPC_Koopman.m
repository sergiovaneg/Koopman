%% Env Init

close all;
clearvars;
clc;
addpath("~/Koopman/MATLAB/");
rng('default');
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% First step - System observation

load(data_source + "data_kalman_definitive.mat");
type = "asState";
L = size(Y,2)-1;

if strcmp(type,"asState")
    X = [X;Y];
end
n_x = size(X,1);
n_u = size(U,1);

M = 20;
X0 = zeros(size(X,1),M);
for i=1:size(X0,1)
    X0(i,:) = random('Normal',mean(X(i,:)),std(X(i,:)),1,M);
end

% Kalman-koopman
[G,~] = Spline_Radial_Obs(X,X0);
G1 = G(:,1:L);
G2 = G(:,2:L+1);
if strcmp(type,"asOutput")
    U = [U(:,2:L+1);Y(:,1:L)]; % For control as output
else
    U = U(:,2:L+1); % For control as state
end

%% Second step - Operator calculation

tic

alpha = 0;
[A,B] = Koopman(G1,G2,U,alpha,size(G2,1));
if strcmp(type,"asOutput")
    [C,D] = Koopman(G2,Y(:,2:L+1),U,alpha,size(Y,1));
else
    C = zeros(size(Y,1),size(G1,1));
    C(3) = 1;
    D = zeros(size(Y,1),size(U,1));
end

save(sprintf(data_source+'kk_%s_M_%i.mat',type,M), ...
    "A","B","C","D","Ts","X0","n_x","n_u");

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;