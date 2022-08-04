%% Env Init

close all;
clearvars;
clc;
addpath("../");
rng('default');
data_source = "~/Documents/Thesis/Linear_MPC/";

%% Parameter selection

obs_type = "radial";
n_g = 75; % M->P in the case of polynomial bases
Ts = 0.01;

%% First step - System observation

files = dir(data_source+"Data_*.mat");
load(data_source+files(1).name);
X1 = z(:,1:end-1);
X2 = z(:,2:end);
Y = z(1,1:end-1);
U = u(:,1:end-1);
for i=2:length(files)
    load(data_source+files(i).name);
    X1 = [X1 z(:,1:end-1)];
    X2 = [X2 z(:,2:end)];
    Y = [Y z(1,1:end-1)];
    U = [U u(:,1:end-1)];
end

n_x = size(X1,1);
n_y = size(Y,1);

if strcmp(obs_type,"radial")
    X0 = zeros(size(X1,1),n_g);
    for i=1:size(X0,1)
        X0(i,:) = random('Normal',mean(X2(i,:)),std(X2(i,:)),1,n_g);
    end
    [G1,~] = Spline_Radial_Obs(X1,X0);
    [G2,~] = Spline_Radial_Obs(X2,X0);
    
elseif strcmp(obs_type,"polynomial")
    [G1,~,~] = Poly_Obs(X1,n_g);
    [G2,~,expts] = Poly_Obs(X2,n_g);
end

%% Second step - Operator calculation

tic

alpha = 1e-5;
[A,B] = Koopman(G1,G2,U,alpha,size(G2,1));
% [C,D] = Koopman(G2,W(:,2:L+1),U,alpha,size(W,1));
C = eye(size(G2,1));
D = zeros(size(G2,1),n_y);

if strcmp(obs_type,"radial")
    save(sprintf(data_source+'vdp_radial_ng_%i.mat',n_g), ...
        "A","B","C","D","Ts","X0","n_x","n_y");
elseif strcmp(obs_type,"polynomial")
    save(sprintf(data_source+'vdp_polynomial_P_%i.mat',n_g), ...
        "A","B","C","D","Ts","n_x","n_y","expts");
end

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;

%% Third step - Trajectory visualization

z_p = zeros(size(z));
z_p(:,1) = z(:,1);
for i=1:L
    if mod(i,25)==0
        aux = z(:,i);
    else
        aux = z_p(:,i);
    end
    if strcmp(obs_type,"radial")
        aux = A*Spline_Radial_Obs(aux,X0)+B*u(:,i);
    elseif strcmp(obs_type,"polynomial")
        aux = A*Poly_Obs(aux,n_g)+B*u(:,i);
    end
    z_p(:,i+1) = aux(1:n_x);
end
figure(2);
scatter(z(1,:),z(2,:));
hold on
scatter(z_p(1,:),z_p(2,:));
hold off;