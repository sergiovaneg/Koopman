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
M = 100;
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

alpha = 0.001;
[A,B] = Koopman(Px,Py,U,alpha);
% Generic way to recover original states
C = Unobserver(Py,Z);
% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

[Xi,Mu] = eig(A');

figure(1);
scatter(real(diag(Mu)),imag(diag(Mu)));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;

% save(sprintf(Data_Source+'Operator_P_%i.mat',P), ...
%     "A","B","C","D","ts");
save(sprintf(Data_Source+'Operator_M_%i.mat',M), ...
    "A","B","C","D","ts","X0");

%% Third Step - Approximation

load(Data_Source+data(1).name);
L = length(0:ts:T);

markerDecay = 0.001;
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
legend("Original Data","Trajectory Prediction (full-operator)");
hold off;

%% Fourth Step - Eigen Discrimination

thr = 0.85;
idx_r = abs(diag(Mu))>thr;
Xi_r = Xi(:,idx_r);
Mu_r = Mu(idx_r,idx_r);

%% Fifth Step - Eigen Approx

error_obs = zeros(L,1);
error_sts = zeros(L,1);

Phi = Xi_r'*g_p(:,1);
% V = (Xi\C')';
g_eig = Xi_r'\Phi;

error_obs(1) = norm(g_eig-g_p(:,1)) / (norm(g_p(:,1))+eps);
error_sts(1) = norm(C*g_eig-z_p(:,1)) / (norm(z_p(:,1))+eps);

for i=1:L-1
    Phi = Mu_r*Phi + Xi_r'*B*u(:,i);
    g_eig = Xi_r'\Phi;

    error_obs(i+1) = norm(g_eig-g_p(:,i+1)) / (norm(g_p(:,i+1))+eps);
    error_sts(i+1) = norm(C*g_eig-z_p(:,i+1)) / (norm(z_p(:,i+1))+eps);
end

figure(3);
plot(0:L-1,error_obs);
hold on;
plot(0:L-1,error_sts);
legend("Normalized observable error","Normalized state error");
hold off;