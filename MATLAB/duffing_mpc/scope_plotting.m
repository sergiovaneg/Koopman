%% Env Init

close all;
clearvars;
clc;
data_source = "~/Documents/Thesis/Nonlinear_MPC_DUFF/";

%% Data retrieval

load(data_source+"data_duffing_definitive.mat");
t_id = 0:Ts:(size(U,2)-1)*Ts;

load(data_source + "scope_data.mat");
t = 0:Ts:(size(r_osc,2)-1)*Ts;

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
plot(t,radial_w_neg);
plot(t,radialcov_w_neg);
plot(t,poly_w_neg);
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial");
ylim([-2,2]);
xlabel("t [s]");
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_neg(1,:));
hold on;
plot(t,radial_x_neg(1,:));
plot(t,radialcov_x_neg(1,:));
plot(t,poly_x_neg(1,:));
plot(t,r_neg(1,:));
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
ylim([-1,.2]);
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_neg(2,:));
hold on;
plot(t,radial_x_neg(2,:));
plot(t,radialcov_x_neg(2,:));
plot(t,poly_x_neg(2,:));
plot(t,r_neg(2,:));
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
ylim([-1,.2]);
xlabel("t [s]");
title("Second state");

%% Step reference

figure(3);

subplot(3,1,1);
plot(t,MPC_w_step);
hold on;
plot(t,radial_w_step);
plot(t,radialcov_w_step);
plot(t,poly_w_step);
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial");
ylim([-2,2]);
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_step(1,:));
hold on;
plot(t,radial_x_step(1,:));
plot(t,radialcov_x_step(1,:));
plot(t,poly_x_step(1,:));
plot(t,r_step(1,:));
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
ylim([0,1.2]);
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_step(2,:));
hold on;
plot(t,radial_x_step(2,:));
plot(t,radialcov_x_step(2,:));
plot(t,poly_x_step(2,:));
plot(t,r_step(2,:));
hold off;
ylim([-.2,1.2]);
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
xlabel("t [s]");
title("Second state");

%% Oscillating reference

figure(4);

subplot(3,1,1);
plot(t,MPC_w_osc);
hold on;
plot(t,radial_w_osc);
plot(t,radialcov_w_osc);
plot(t,poly_w_osc);
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial");
ylim([-2,2]);
xlabel("t [s]");
title("Control signal");

subplot(3,1,2);
plot(t,MPC_x_osc(1,:));
hold on;
plot(t,radial_x_osc(1,:));
plot(t,radialcov_x_osc(1,:));
plot(t,poly_x_osc(1,:));
plot(t,r_osc(1,:));
hold off;
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
xlabel("t [s]");
title("First state");

subplot(3,1,3);
plot(t,MPC_x_osc(2,:));
hold on;
plot(t,radial_x_osc(2,:));
plot(t,radialcov_x_osc(2,:));
plot(t,poly_x_osc(2,:));
plot(t,r_osc(2,:));
hold off;
ylim([-1.2,1.2]);
legend("MPC", ...
        "Koopman - Spline-radial", ...
        "Koopman - Spline-radial + Kalman covariance", ...
        "Koopman - Polynomial", ...
        "Reference");
xlabel("t [s]");
title("Second state");