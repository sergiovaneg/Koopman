%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/VanDerPol_Noisy_Unsteady_Input/";

%% First Step - System observation

data = dir(Data_Source+"Data_*.mat");

K = 0;
for f=1:length(data)
    load(Data_Source+data(f).name,"L");
    K = K+L; 
end

load(Data_Source+data(randi(f)).name);
M = 5;
X0 = 2*rand(size(z,1),M)-1;
% X0 = z(:,randperm(L+1,M));
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

    [g_t,~] = Spline_Radial_Obs(z,X0);

    Px(:,idx+1:idx+L) = g_t(:,1:end-1);
    Py(:,idx+1:idx+L) = g_t(:,2:end);
    Z(:,idx+1:idx+L) = z(:,2:end);
    U(:,idx+1:idx+L) = u(:,1:end-1);

    idx = idx+L;
end

%% Second Step - Operator calculation
tic

alpha = 0;
fprintf("Current coefficient: %f\n", alpha);
[A,B] = Koopman(Px,Py,U,alpha,n-M);
% Generic way to recover original states
% C = Unobserver(Py,Z);
% Original states recovered by convention
% (the first n observers are the original states)
C = zeros(size(Z,1),size(A,2));
C(1:size(Z,1),1:size(Z,1)) = eye(size(Z,1));

% Recovery of original states independent from input
D = zeros(size(Z,1),size(U,1));

save(sprintf(Data_Source+'Radial/Operator_M_%i_alpha_none.mat',M), ...
    "A","B","C","D","ts","X0");

for i=0:4
    alpha = 10^(-i);
    fprintf("Current coefficient: %f\n", alpha);
    [A,B] = Koopman(Px,Py,U,alpha,n-M);

    % Generic way to recover original states
    % C = Unobserver(Py,Z);

    % Original states recovered by convention
    % (the first n observers are the original states)
    C = zeros(size(Z,1),size(A,2));
    C(1:size(Z,1),1:size(Z,1)) = eye(size(Z,1));

    % Recovery of original states independent from input
    D = zeros(size(Z,1),size(U,1));

    save(sprintf(Data_Source+'Radial/Operator_M_%i_alpha_%i.mat',M,i), ...
        "A","B","C","D","ts","X0");
end

toc

Lambda = eig(A(:,1:n-M));
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;

%% Third Step - Approximation

load(Data_Source+data(1).name);
L = length(0:ts:T);

markerDecay = 0.001;
figure(2);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)));
hold on;

g_p = zeros(n,L);
[g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);

for i=1:L-1
    g_p(1:2,i+1) = A*g_p(:,i) + B*u(:,i);
    g_p(:,i+1) = Spline_Radial_Obs(g_p(1:2,i+1),X0);
end

z_p = C*g_p;

scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
legend("Original Data","Trajectory Prediction");
hold off;
