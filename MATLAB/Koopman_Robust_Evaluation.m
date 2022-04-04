%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/";

%% Operator retrieval

M = 100;
Alpha = (4:-1:0)';
load(Data_Source+ ...
    'VanDerPol_Unsteady_Input/Radial/Operator_alpha_none.mat',"ts");

%% Trajectory generation

T = 10;

z0 = 2*rand(2,1) - 1;
sigma = randn(1);
u_t = 0:ts:T;
u = 0 * cos(u_t);

[t,z] = ode113(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
z = z';
L = length(0:ts:T);

%% Trajectory approximation

markerDecay = 0.005;

figure(1);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)),'filled');
title("Clean training data");
xlim([-1 1]); ylim([-1 1]);
hold on;

load(Data_Source+'VanDerPol_Unsteady_Input/Radial/Operator_alpha_none.mat');
g_p = zeros(size(B,1),L);
g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
for j=1:L-1
    g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
end
z_p = C*g_p;
scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)),'filled');

for i=1:length(Alpha)
    load(sprintf(Data_Source ...
        +'VanDerPol_Unsteady_Input/Radial/Operator_alpha_%i.mat',Alpha(i)));
    g_p = zeros(size(B,1),L);
    g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
    
    for j=1:L-1
        g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
    end
    
    z_p = C*g_p;
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
end
legend(["Reference"; ...
    "Alpha=0"; ...
    repmat("Alpha=10^-",length(Alpha),1)+int2str(Alpha)]);
hold off;


figure(2);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)),'filled');
title("Noisy training data");
xlim([-1 1]); ylim([-1 1]);
hold on;

load(Data_Source+ ...
    'VanDerPol_Noisy_Unsteady_Input/Radial/Operator_alpha_none.mat');
g_p = zeros(size(B,1),L);
g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
for j=1:L-1
    g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
end
z_p = C*g_p;
scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)),'filled');

for i=1:length(Alpha)
    load(sprintf(Data_Source ...
        +'VanDerPol_Noisy_Unsteady_Input/Radial/Operator_alpha_%i.mat', ...
        Alpha(i)));
    g_p = zeros(size(B,1),L);
    g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
    
    for j=1:L-1
        g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
    end
    
    z_p = C*g_p;
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
end
legend(["Reference"; ...
    "Alpha=0"; ...
    repmat("Alpha = 10^-",length(Alpha),1)+int2str(Alpha)]);
hold off;