%% Env Init

close all;
clearvars;
clc;
isSimulate = false;
Data_Source = "Duffing_Data/";

%% Oscillator

dt = 1e-2;
T = 1;
N_Sim = 200;

alpha = 1;
beta = -1;
gamma = 0;
delta = 0;
omega = 1;
mu = 1;

if isSimulate
    delete(Data_Source+"*.mat");
    for f=1:N_Sim
        z0 = 2*rand(2,1) - 1;
%         [t,z] = ode113(@(t,z) Duffing(t,z,alpha,beta,gamma,delta,omega), ...
%                         0:dt:T, z0);
        [t,z] = ode113(@(t,z) VanDerPol(t,z,mu), 0:dt:T, z0);
        % m = matfile(sprintf("Duffing_Data/%i.mat",f),"Writable",true);
        m = matfile(sprintf("VanDerPol_Data/%i.mat",f),"Writable",true);
        m.L = length(z)-1;
        m.T = T;
        m.dt = dt;
        m.z = z';
    end
end

%% DMD + Koopman

n_data = 100;

data = dir(Data_Source+"*.mat");
idx = randperm(length(data));

load(Data_Source+data(idx(1)).name);
P = 3;

[g_t,n] = Poly_Obs(z,P);

g = zeros(n, n_data*size(g_t,2));
g(:,1:L+1) = g_t;

for f=2:n_data
    load(Data_Source+data(idx(f)).name);

    [g_t,~] = Poly_Obs(z,P);

    g(:,(L+1)*(f-1)+1:(L+1)*f) = g_t;
end

% [V,Lambda] = CM_DMD(g,n);
% [V,Lambda] = SVD_DMD(g);
[V,Lambda,W] = Exact_DMD(g);
eigVs = diag(Lambda);

UN = pinv(g(:,1:end-1)')*g(:,2:end)';
[Phi,Lambda_t] = eig(UN);
[Phi,Lambda_t] = Reorder_Eigen(Phi,Lambda_t,Lambda);

figure(1);
subplot(1,2,1);
scatter(z(1,:),z(2,:));

figure(2);
scatter(real(eigVs),imag(eigVs), 'LineWidth', 2);
hold on;
scatter(real(diag(Lambda_t)),imag(diag(Lambda_t)));
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
xlim([-1 1]);
ylim([-1 1]);
hold off;

%% Approximation

M = L;
z_p = zeros(n,L+1); % Predicted Output
i0 = 1; % Starting point
Lambda_i = eye(n);
proj = Phi'*g_t(:,i0);
z_p(:,1) = W*Lambda_i*proj;

g_p = zeros(n,L+1);
g_p(:,1) = g_t(:,i0);

g_k = zeros(size(g_t));
g_k(:,1) = Poly_Obs(z(:,i0),P);

for i=1:M
    z_p(:,i+1) = V*Lambda_i*proj;
    Lambda_i = Lambda_i*Lambda;

    g_p(:,i+1) = V*Lambda*(Phi'*g_p(:,i));

    g_k(:,i+1) = UN'*g_k(:,i);
end

figure(1);
subplot(1,2,2);
hold on;
scatter(real(z_p(2,1:M+1)),real(z_p(3,1:M+1)));
scatter(real(g_p(2,1:M+1)),real(g_p(3,1:M+1)));
scatter(real(g_k(2,1:M+1)),real(g_k(3,1:M+1)));
legend("Single-observable DMD", ...
    "Previous-observable DMD", ...
    "Direct Koopman");
hold off;