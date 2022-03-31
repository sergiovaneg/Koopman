%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/VanDerPol_Unsteady_Input/";

%% Operator retrieval

P = [5;10;11];
M = [10;20;50;100;150];
load(Data_Source+'Operator_P_5.mat',"ts");

%% Trajectory generation

T = 3;

z0 = 4*rand(2,1) - 2;
sigma = randn(1);
u_t = 0:ts:T;
u = 0 * cos(u_t);

[t,z] = ode113(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
z = z';
L = length(0:ts:T);

%% Trajectory approximation

markerDecay = 0.003;

figure(1);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)));
hold on;
for i=1:length(P)
    load(sprintf(Data_Source+'Operator_P_%i.mat',P(i)));
    g_p = zeros(size(B,1),L);
    g_p(:,1) = Poly_Obs(z(:,1),P(i));
    
    for j=1:L-1
        g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
    end
    
    z_p = C*g_p;
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
end
legend(["Reference";int2str(P)]);
hold off;

figure(2);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)));
% plot(z(2,:));
hold on;
for i=1:length(M)
    load(sprintf(Data_Source+'Operator_M_%i.mat',M(i)));
    g_p = zeros(size(B,1),L);
    g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
    
    for j=1:L-1
        g_p(:,j+1) = A*g_p(:,j) + B*u(:,j);
    end
    
    z_p = C*g_p;
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
%     plot(z_p(2,:));
end
legend(["Reference";int2str(M)]);
hold off;