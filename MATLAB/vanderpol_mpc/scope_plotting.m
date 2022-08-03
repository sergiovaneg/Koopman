%% Env Init

close all;
clearvars;
clc;
data_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% Data retrieval

load(data_source+"data_kalman_definitive.mat");
t_id = 0:Ts:(size(U,2)-1)*Ts;

load(data_source + "scope_data.mat");
t = 0:Ts:(size(r_osc,2)-1)*Ts;
t_stability = 0:Ts:(size(stability_osc,2)-1)*Ts;

%% Identification set

figure(1);

subplot(3,1,1);
plot(t_id, Y);
xlim([0,t_id(end)]);
ylim([-2,2]);
xlabel("t [s]");
title("Control signal - MPC");

subplot(3,1,2);
plot(t_id,X(1,:),LineWidth=1.5);
hold on;
plot(t_id,U(3,:))
plot(t_id,U(1,:));
hold off;
legend("Kalman-estimated","Measured","Reference");
xlim([0,t_id(end)]);
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t_id,X(2,:));
hold on;
plot(t_id,U(2,:));
hold off;
legend("Kalman-estimated","Reference");
xlim([0,t_id(end)]);
ylim([-1.2,1.2]);
xlabel("t [s]");
title("Second state");

%% Negative reference

figure(2);

subplot(3,1,1);
plot(t,MPC_w_neg);
hold on;
plot(t,asOutput_w_neg);
plot(t,asState_w_neg);
hold off;
legend("MPC","Koopman - As output", "Koopman - As state");
ylim([-2,2]);
xlabel("t [s]");
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_neg(1,:));
hold on;
plot(t,asOutput_x_neg(1,:));
plot(t,asState_x_neg(1,:));
plot(t,r_neg(1,:));
hold off;
legend("MPC","Koopman - As output", "Koopman - As state","Reference");
ylim([-1,.2]);
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_neg(2,:));
hold on;
plot(t,asOutput_x_neg(2,:));
plot(t,asState_x_neg(2,:));
plot(t,r_neg(2,:));
hold off;
legend("MPC","Koopman - As output", "Koopman - As state","Reference");
ylim([-1,.2]);
xlabel("t [s]");
title("Second state");

%% Step reference

figure(3);

subplot(3,1,1);
plot(t,MPC_w_step);
hold on;
plot(t,asOutput_w_step);
plot(t,asState_w_step);
hold off;
legend("MPC","Koopman - As output", "Koopman - As state", ...
    Location="southeast");
ylim([-2,2]);
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_step(1,:));
hold on;
plot(t,asOutput_x_step(1,:));
plot(t,asState_x_step(1,:));
plot(t,r_step(1,:));
hold off;
legend("MPC","Koopman - As output", "Koopman - As state","Reference", ...
    Location="southeast");
ylim([0,1.2]);
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_step(2,:));
hold on;
plot(t,asOutput_x_step(2,:));
plot(t,asState_x_step(2,:));
plot(t,r_step(2,:));
hold off;
ylim([-.2,1.2]);
legend("MPC","Koopman - As output", "Koopman - As state","Reference");
xlabel("t [s]");
title("Second state");

%% Oscillating reference

figure(4);

subplot(3,1,1);
plot(t,MPC_w_osc);
hold on;
plot(t,asOutput_w_osc);
plot(t,asState_w_osc);
hold off;
legend("MPC","Koopman - As output", "Koopman - As state");
ylim([-2,2]);
xlabel("t [s]");
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_osc(1,:));
hold on;
plot(t,asOutput_x_osc(1,:));
plot(t,asState_x_osc(1,:));
plot(t,r_osc(1,:));
hold off;
legend("MPC","Koopman - As output", "Koopman - As state","Reference", ...
    Location="southeast");
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_osc(2,:));
hold on;
plot(t,asOutput_x_osc(2,:));
plot(t,asState_x_osc(2,:));
plot(t,r_osc(2,:));
hold off;
ylim([-1.2,1.2]);
legend("MPC","Koopman - As output", "Koopman - As state","Reference", ...
    Location="southeast");
xlabel("t [s]");
title("Second state");

%% Stability verification

figure(5);

subplot(2,1,1);
plot(t_stability,st_x_step(1,:));
hold on;
plot(t_stability,unst_x_step(1,:));
plot(t_stability,stability_step(1,:));
hold off;
legend("Stable", "Unstable","Reference",Location="southeast");
xlim([0 20]);
xlabel("t [s]");
title("First state - Step");

subplot(2,1,2);
plot(t_stability,st_w_step);
hold on;
plot(t_stability,unst_w_step);
hold off;
legend("Stable", "Unstable");
xlim([0 20]); ylim([-2,2]);
xlabel("t [s]");
title("Control signal - Step");