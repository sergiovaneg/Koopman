%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/VanDerPol_Noisy_Unsteady_Input/";

%% First Step - System observation

data = dir(Data_Source+"Data_*.mat");
load(Data_Source+data(1).name);

K = 0;
for f=1:length(data)
    load(Data_Source+data(f).name,"L");
    K = K+L; 
end

% P = 11;
% [g_t,n] = Poly_Obs(z,P);
M = 250;
X0 = 2*rand(size(z,1),M)-1;
[g_t,n] = Spline_Radial_Obs(z,X0);

Px = zeros(n,K);
Py = Px;
Z = zeros(size(z,1),K);
U = zeros(size(u,1),K);

Px(:,1:L) = g_t(:,1:end-1);
Py(:,1:L) = g_t(:,2:end);
Z(:,1:L) = z(:,2:end);
U(:,1:L) = u(:,1:end-1);

idx = L;
for f=2:length(data)
    load(Data_Source+data(f).name);
%     [g_t,~] = Poly_Obs(z,P);
    [g_t,~] = Spline_Radial_Obs(z,X0);

    Px(:,idx+1:idx+L) = g_t(:,1:end-1);
    Py(:,idx+1:idx+L) = g_t(:,2:end);
    Z(:,idx+1:idx+L) = z(:,2:end);
    U(:,idx+1:idx+L) = u(:,1:end-1);

    idx = idx+L;
end

%% Second Step - Operator calculation

alpha = 0.000;
[A,B] = Koopman(Px,Py,U,alpha);
% Generic way to recover original states
C = Unobserver(Py,Z);
% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

[~,Mu,Xi] = eig(A);

figure(1);
scatter(real(diag(Mu)),imag(diag(Mu)));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;

% save(sprintf(Data_Source+'Operator_P_%i.mat',P), ...
%     "A","B","C","D","ts");
% save(sprintf(Data_Source+'Operator_M_%i.mat',M), ...
%     "A","B","C","D","ts","X0");

%% Third Step - Approximation

load(Data_Source+data(1).name);
L = length(0:ts:T);

markerDecay = 0.005;
figure(2);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)));
hold on;

g_p = zeros(size(g_t,1),L);
% [g_p(:,1),~] = Poly_Obs(z(:,1),P);
[g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);

for i=1:L-1
    g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
end

z_p = C*g_p;

scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));

%% Fourth Step - Eigen Discrimination

thr = 0.7;
idx_r = abs(diag(Mu))>thr;
Xi_r = Xi(:,idx_r);
Mu_r = Mu(idx_r,idx_r);

%% Fifth Step - Eigen Approx

Phi = zeros(length(Mu_r),L);
Phi(:,1) = Xi_r'*g_p(:,1);

for i=1:L-1
    Phi(:,i+1) = Mu_r*Phi(:,i) + Xi_r'*B*u(:,i);
end

g_eig = Xi_r'\Phi;
z_eig = C*g_eig;
error_obs = vecnorm(g_eig-g_p) ./ (vecnorm(g_p)+eps);
error_sts = vecnorm(z_eig-z_p) ./ (vecnorm(z_p)+eps);

scatter(real(z_eig(1,:)),real(z_eig(2,:)),36*exp(-markerDecay*(0:L-1)));
legend("Original Data", ...
    "Trajectory Prediction (full-operator)", ...
    "Trajectory Prediction - (Eigen aproximation)");
hold off;

figure(3);
plot(0:L-1,error_obs);
hold on;
plot(0:L-1,error_sts);
legend("Normalized observable error","Normalized state error");
hold off;