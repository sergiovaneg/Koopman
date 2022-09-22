%% Env Init

close all;
clearvars;
clc;
data_source = "~/Documents/modelway/";
set(0,'DefaultFigureWindowStyle','docked')

%% Data retrieval

load("./results.mat");
Ts = 0.01;
t = 0:Ts:100;

t_start = 15;
t_limit = 35;

%% Errors table

no_exp = length(fieldnames(results));
no_ng = length(results.step.K_lMPC.covradial);
error = cell(no_exp*(1+4*no_ng),6);

error{1,1} = "step"; error{1,2} = "EKF_nlMPC"; error{1,3} = "";
error{1,4} = 0;
error{1,5} = get_NRMSE(results.step.EKF_nlMPC.NRMSE,1);
error{1,6} = get_NRMSE(results.step.EKF_nlMPC.NRMSE,2);
for i=1:no_ng
    error{4*i-2,1} = "step"; error{4*i-2,2} = "K_nlMPC";
    error{4*i-2,3} = "radial";
    error{4*i-2,4} = results.step.K_nlMPC.radial{i}.n_g;
    error{4*i-2,5} = get_NRMSE(results.step.K_nlMPC.radial{i}.NRMSE,1);
    error{4*i-2,6} = get_NRMSE(results.step.K_nlMPC.radial{i}.NRMSE,2);

    error{4*i-1,1} = "step"; error{4*i-1,2} = "K_nlMPC";
    error{4*i-1,3} = "covradial";
    error{4*i-1,4} = results.step.K_nlMPC.covradial{i}.n_g;
    error{4*i-1,5} = get_NRMSE(results.step.K_nlMPC.covradial{i}.NRMSE,1);
    error{4*i-1,6} = get_NRMSE(results.step.K_nlMPC.covradial{i}.NRMSE,2);

    error{4*i,1} = "step"; error{4*i,2} = "K_lMPC";
    error{4*i,3} = "radial";
    error{4*i,4} = results.step.K_lMPC.radial{i}.n_g;
    error{4*i,5} = get_NRMSE(results.step.K_lMPC.radial{i}.NRMSE,1);
    error{4*i,6} = get_NRMSE(results.step.K_lMPC.radial{i}.NRMSE,2);

    error{4*i+1,1} = "step"; error{4*i+1,2} = "K_lMPC";
    error{4*i+1,3} = "covradial";
    error{4*i+1,4} = results.step.K_lMPC.covradial{i}.n_g;
    error{4*i+1,5} = get_NRMSE(results.step.K_lMPC.covradial{i}.NRMSE,1);
    error{4*i+1,6} = get_NRMSE(results.step.K_lMPC.covradial{i}.NRMSE,2);
end
idx = 4*i+1;

error{idx+1,1} = "osc"; error{idx+1,2} = "EKF_nlMPC"; error{idx+1,3} = "";
error{idx+1,4} = 0;
error{idx+1,5} = get_NRMSE(results.osc.EKF_nlMPC.NRMSE,1);
error{idx+1,6} = get_NRMSE(results.osc.EKF_nlMPC.NRMSE,2);
for j=1:no_ng
    error{idx+4*j-2,1} = "osc"; error{idx+4*j-2,2} = "K_nlMPC";
    error{idx+4*j-2,3} = "radial";
    error{idx+4*j-2,4} = results.osc.K_nlMPC.radial{j}.n_g;
    error{idx+4*j-2,5} = get_NRMSE(results.osc.K_nlMPC.radial{j}.NRMSE,1);
    error{idx+4*j-2,6} = get_NRMSE(results.osc.K_nlMPC.radial{j}.NRMSE,2);

    error{idx+4*j-1,1} = "osc"; error{idx+4*j-1,2} = "K_nlMPC";
    error{idx+4*j-1,3} = "covradial";
    error{idx+4*j-1,4} = results.osc.K_nlMPC.covradial{j}.n_g;
    error{idx+4*j-1,5} = get_NRMSE(results.osc.K_nlMPC.covradial{j}.NRMSE,1);
    error{idx+4*j-1,6} = get_NRMSE(results.osc.K_nlMPC.covradial{j}.NRMSE,2);

    error{idx+4*j,1} = "osc"; error{idx+4*j,2} = "K_lMPC";
    error{idx+4*j,3} = "radial";
    error{idx+4*j,4} = results.osc.K_lMPC.radial{j}.n_g;
    error{idx+4*j,5} = get_NRMSE(results.osc.K_lMPC.radial{j}.NRMSE,1);
    error{idx+4*j,6} = get_NRMSE(results.osc.K_lMPC.radial{j}.NRMSE,2);

    error{idx+4*j+1,1} = "osc"; error{idx+4*j+1,2} = "K_lMPC";
    error{idx+4*j+1,3} = "covradial";
    error{idx+4*j+1,4} = results.osc.K_lMPC.covradial{j}.n_g;
    error{idx+4*j+1,5} = get_NRMSE(results.osc.K_lMPC.covradial{j}.NRMSE,1);
    error{idx+4*j+1,6} = get_NRMSE(results.osc.K_lMPC.covradial{j}.NRMSE,2);
end

error = cell2table(error, "VariableNames", ...
            ["Reference","Controller","Observable","Size","NRMSE_1","NRMSE_2"]);

%% Identification set (skipped for now)

%% Step reference

f = figure(2);

% Control signal
subplot(3,1,1);
plot(t, results.step.EKF_nlMPC.w); hold on; grid on;
plot(t, results.step.K_nlMPC.radial{end}.w);
plot(t, results.step.K_nlMPC.covradial{end}.w);
title("W"); xlim([t_start,t_limit]); 
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", ...
    Location="southwest");

% First state
subplot(3,1,2);
plot(t, results.step.EKF_nlMPC.x(1,:)); hold on; grid on;
plot(t, results.step.K_nlMPC.radial{end}.x(1,:));
plot(t, results.step.K_nlMPC.covradial{end}.x(1,:));
plot(t, results.step.ref(1,:));
title("X_1"); xlim([t_start,t_limit]); ylim([-1.2 1.2]);
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", "Reference", ...
    Location="southwest");

% Second state
subplot(3,1,3);
plot(t, results.step.EKF_nlMPC.x(2,:)); hold on; grid on;
plot(t, results.step.K_nlMPC.radial{end}.x(2,:));
plot(t, results.step.K_nlMPC.covradial{end}.x(2,:));
plot(t, results.step.ref(2,:));
title("X_2"); xlim([t_start,t_limit]); ylim([-1.2 1.2]);
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", "Reference", ...
    Location="southwest");

exportgraphics(f, './step_reference.eps');

%% Oscillating reference

f = figure(3);

% Control signal
subplot(3,1,1);
plot(t, results.osc.EKF_nlMPC.w); hold on; grid on;
plot(t, results.osc.K_nlMPC.radial{end}.w);
plot(t, results.osc.K_nlMPC.covradial{end}.w);
title("W"); xlim([t_start,t_limit]); 
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", ...
    Location="southwest");

% First state
subplot(3,1,2);
plot(t, results.osc.EKF_nlMPC.x(1,:)); hold on; grid on;
plot(t, results.osc.K_nlMPC.radial{end}.x(1,:));
plot(t, results.osc.K_nlMPC.covradial{end}.x(1,:));
plot(t, results.osc.ref(1,:));
title("X_1"); xlim([t_start,t_limit]); ylim([-1.2 1.2]);
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", "Reference", ...
    Location="southwest");

% Second state
subplot(3,1,3);
plot(t, results.osc.EKF_nlMPC.x(2,:)); hold on; grid on;
plot(t, results.osc.K_nlMPC.radial{end}.x(2,:));
plot(t, results.osc.K_nlMPC.covradial{end}.x(2,:));
plot(t, results.osc.ref(2,:));
title("X_2"); xlim([t_start,t_limit]); ylim([-1.2 1.2]);
legend("EKF nlMPC","K-radial nlMPC","K-covradial nlMPC", "Reference", ...
    Location="southwest");

exportgraphics(f, './osc_reference.eps');