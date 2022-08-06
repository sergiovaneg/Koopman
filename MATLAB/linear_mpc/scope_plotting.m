%% Env Init

close all;
clearvars;
clc;
data_source = "~/Documents/Thesis/Linear_MPC/";

%% Data retrieval

load(data_source+"data_joint.mat",'U','X','Ts');
t_id = 0:Ts:(size(X,2)-1)*Ts;

load(data_source + "scope_data.mat");
t = 0:Ts:(size(r,2)-1)*Ts;

t_start = 15;
t_limit = 10;

%% Identification set

figure(1);

subplot(3,1,1);
plot(t_id, U);
xlim([0,t_id(end)]);
ylim([-5,5]);
xlabel("t [s]");
title("Input Signal - VdP oscillator");

subplot(3,1,2);
plot(t_id,X(1,:));
xlim([0,t_id(end)]);
xlabel("t [s]");
title("(Noisy) First state - VdP oscillator");

subplot(3,1,3);
plot(t_id,X(2,:));
xlim([0,t_id(end)]);
xlabel("t [s]");
title("(Noisy) Second state - VdP oscillator");

%% Oscillating reference

figure(2);

subplot(2,1,1);
plot(t,w_nl);
xlim([t_start t_start+t_limit]);
ylim([-5,5]);
xlabel("t [s]");
title("Control signal - Nonlinear MPC");

subplot(2,1,2);
plot(t,w_005,'--');
hold on;
plot(t,w_010,':');
plot(t,w_025,':');
plot(t,w_050,'--');
plot(t,w_075,':');
plot(t,w_100,'--');
hold off;
legend("5 observables", ...
        "10 observables", ...
        "25 observables", ...
        "50 observables", ...
        "75 observables", ...
        "100 observables");
xlim([t_start t_start+t_limit]);
ylim([-5,5]);
xlabel("t [s]");
title("Control signal - Koopman MPC");

figure(3);

subplot(2,1,1);
plot(t,x_nl(1,:));
hold on;
plot(t,x_005(1,:),'--');
plot(t,x_010(1,:),':');
plot(t,x_025(1,:),':');
plot(t,x_050(1,:),'--');
plot(t,x_075(1,:),':');
plot(t,x_100(1,:),'--');
plot(t,r(1,:),'Black','LineWidth',2);
hold off;
legend("Nonlinear MPC", ...
        "KMPC - 5 observables", ...
        "KMPC - 10 observables", ...
        "KMPC - 25 observables", ...
        "KMPC - 50 observables", ...
        "KMPC - 75 observables", ...
        "KMPC - 100 observables", ...
        "Reference");
xlim([t_start t_start+t_limit]);
ylim([-2,2]);
xlabel("t [s]");
title("First state");

subplot(2,1,2);
plot(t,x_nl(2,:));
hold on;
plot(t,x_005(2,:),'--');
plot(t,x_010(2,:),':');
plot(t,x_025(2,:),':');
plot(t,x_050(2,:),'--');
plot(t,x_075(2,:),':');
plot(t,x_100(2,:),'--');
plot(t,r(2,:),'Black','LineWidth',2);
hold off;
legend("Nonlinear MPC", ...
        "KMPC - 5 observables", ...
        "KMPC - 10 observables", ...
        "KMPC - 25 observables", ...
        "KMPC - 50 observables", ...
        "KMPC - 75 observables", ...
        "KMPC - 100 observables", ...
        "Reference");
xlim([t_start t_start+t_limit]);
ylim([-1.5,1.5]);
xlabel("t [s]");
title("Second state");

%% Identification set (zoomed in)

figure(4);

subplot(3,1,1);
plot(t_id, U);
xlim([0 t_limit]);
ylim([-5,5]);
xlabel("t [s]");
title("Input Signal - VdP oscillator");

subplot(3,1,2);
plot(t_id,X(1,:));
xlim([0 t_limit]);
xlabel("t [s]");
title("(Noisy) First state - VdP oscillator");

subplot(3,1,3);
plot(t_id,X(2,:));
xlim([0 t_limit]);
xlabel("t [s]");
title("(Noisy) Second state - VdP oscillator");