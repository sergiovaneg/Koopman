%% Env Init

close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Thesis/Nonlinear_MPC_DUFF/";

%% Trajectory generation

Ts = 0.01;
Tf = 100;
R = zeros(2,round(Tf/Ts)+1);
R(:,1) = 2*rand(2,1)-1;
U = 10*rand(1,size(R,2))-5;
for l=1:size(R,2)-1
    R(:,l+1) = duff_DT0(R(:,l),U(l),Ts);
end

%% Plot and Export

figure(1);
scatter(R(1,:),R(2,:));
xlim([-2 2]); ylim([-2 2]);
save(data_source+"reference_duffing_oscillating","R");