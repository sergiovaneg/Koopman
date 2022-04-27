%% Env Init

close all;
clearvars;
clc;
Data_Source = "~/Documents/Thesis/";

%% Operator retrieval

M = 30;
Alpha = (4:-1:0)';
load(Data_Source+ ...
    'VanDerPol_Clean_Unsteady_Input/Radial/Operator_M_30_alpha_none.mat',"ts");

%% Trajectory generation

T = 10;

% z0 = 2*rand(2,1) - 1;
z0 = [0;0];
sigma = randn(1);
u_t = 0:ts:T;
u = sigma * cos(u_t);
% u = ones(size(u_t));

[t,z] = ode113(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
z = z';
L = length(0:ts:T);

%% Trajectory approximation

markerDecay = 0.005;

figure(1);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)),'filled');
title("Clean training data");
hold on;

load(Data_Source+ ...
    sprintf('VanDerPol_Clean_Unsteady_Input/Radial/Operator_M_%i_alpha_none.mat',M));
figure(2);
Lambda = eig(A(:,1:2));
scatter(real(Lambda), imag(Lambda));
title("Clean training data");
hold on;

g_p = zeros(size(A,2),L);
g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
for j=1:L-1
    g_p(1:2,j+1) = A*g_p(:,j) + B*u(:,j);
    g_p(:,j+1) = Spline_Radial_Obs(g_p(1:2,j+1),X0);
end
z_p = C*g_p;

figure(1);
scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)),'filled');

for i=1:length(Alpha)
    load(sprintf(Data_Source ...
        +'VanDerPol_Clean_Unsteady_Input/Radial/Operator_M_%i_alpha_%i.mat',M,Alpha(i)));

    g_p = zeros(size(A,2),L);
    g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
    
    for j=1:L-1
        g_p(1:2,j+1) = A*g_p(:,j) + B*u(:,j);
        g_p(:,j+1) = Spline_Radial_Obs(g_p(1:2,j+1),X0);
    end
    
    z_p = C*g_p;
    
    figure(1);
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
end
legend(["Reference"; ...
    "Alpha=0"; ...
    repmat("Alpha=10^-",length(Alpha),1)+int2str(Alpha)], ...
    'Location','southeast');
hold off;

figure(2);
Lambda = eig(A(:,1:2));
scatter(real(Lambda), imag(Lambda));
legend(["Alpha=0"; ...
    "Alpha=1"], ...
    'Location','southwest');
hold off;


figure(3);
scatter(z(1,:),z(2,:),36*exp(-markerDecay*(0:L-1)),'filled');
title("Noisy training data");
hold on;

load(Data_Source+ ...
    sprintf('VanDerPol_Noisy_Unsteady_Input/Radial/Operator_M_%i_alpha_none.mat',M));
figure(4);
Lambda = eig(A(:,1:2));
scatter(real(Lambda), imag(Lambda));
title("Noisy training data");
hold on;

g_p = zeros(size(A,2),L);
g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
for j=1:L-1
    g_p(1:2,j+1) = A*g_p(:,j) + B*u(:,j);
    g_p(:,j+1) = Spline_Radial_Obs(g_p(1:2,j+1),X0);
end
z_p = C*g_p;

figure(3);
scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)),'filled');

for i=1:length(Alpha)
    load(sprintf(Data_Source ...
        +'VanDerPol_Noisy_Unsteady_Input/Radial/Operator_M_%i_alpha_%i.mat', ...
        M,Alpha(i)));
    g_p = zeros(size(A,2),L);
    g_p(:,1) = Spline_Radial_Obs(z(:,1),X0);
    
    for j=1:L-1
        g_p(1:2,j+1) = A*g_p(:,j) + B*u(:,j);
        g_p(:,j+1) = Spline_Radial_Obs(g_p(1:2,j+1),X0);
    end
    
    z_p = C*g_p;

    figure(3);
    scatter(z_p(1,:),z_p(2,:),36*exp(-markerDecay*(0:L-1)));
end
legend(["Reference"; ...
    "Alpha=0"; ...
    repmat("Alpha = 10^-",length(Alpha),1)+int2str(Alpha)], ...
    'Location','southeast');
hold off;

figure(4);
Lambda = eig(A(:,1:2));
scatter(real(Lambda), imag(Lambda));
legend(["Alpha=0"; ...
    "Alpha=1"], ...
    'Location','southwest');
hold off;