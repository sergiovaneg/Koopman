%% Env Init

close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Modelway/EKF_MPC_VDP/";
nl_source = "~/Documents/Thesis/Nonlinear_MPC_VDP/";

%% lMPC creation

% load Koopman VDP
load(data_source+"vdp_radial_ng_75.mat");
A_VDP = A; B_VDP = B; C_VDP = C; D_VDP = D;
X0_VDP = X0;

% Definition
oscillator = ss(A_VDP,B_VDP,C_VDP,D_VDP,Ts);
weights = zeros();
controller = mpc(oscillator,Ts,25,5);

% Weights - MV
controller.Weights.MV = 0;
controller.Weights.ManipulatedVariablesRate = 0;
controller.MV.Max = 2;
controller.MV.Min = -2;

% Weights - OV
controller.Weights.OV = [1 zeros(1,length(A)-1)];
controller.OV(2).Max = 1;
controller.OV(2).Min = -1;

% Initial state
ctrl_0 = mpcstate(controller);
ctrl_0.Plant = Spline_Radial_Obs([0;0],X0);

%% Nonlinear MPC comparison setup

% Load nlMPC
load(nl_source+"vdp_mpc_definitive.mat");

% Bus creation
createParameterBus(nlobj, ...
    ['Kalman_nlMPC' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

createParameterBus(nlobj, ...
    ['Koopman_nlMPC' '/vdpMPC'], ...
    'Ts_Bus',{Ts});

%% External reference setup

load(data_source+"data_joint.mat",'R1','R2');
Tf = 1e2;
eta = 0.001;

R1_osc = R1;
R2_osc = R2;
results.osc.ref = [R1_osc.Var1';R2_osc.Var1'];

step_length = 10;
aux = zeros(2,Tf/Ts+1);
for i=1:2:round(Tf/step_length)
    aux(1,(i-1)*round(step_length/Ts)+1:i*round(step_length/Ts)) = 1;
end
aux(2,:) = filter([1,-1],1,aux(1,:),0,2)/(2*Ts);
R1_step = array2timetable(aux(1,:)',"TimeStep",seconds(Ts));
R2_step = array2timetable(aux(2,:)',"TimeStep",seconds(Ts));
results.step.ref = [R1_step.Var1';R2_step.Var1'];
clear aux;

%% Simulations

NGs = [10 20 50 100];
for i=0:1
    % Reference selection
    if logical(i)
        R1 = R1_step;
        R2 = R2_step;
    else
        R1 = R1_osc;
        R2 = R2_osc;
    end

    try
        simout = sim("Kalman_nlMPC.slx");
        aux.simout = simout;
        aux.RMSE = rmse(simout.X_hat,simout.states,1)';
        aux.x = simout.X';
        aux.x_hat = simout.X_hat';
        aux.w = simout.W';
    catch ME
        aux.simout = NaN;
        aux.NRMSE = NaN;
        aux.x = NaN;
        aux.x_hat = NaN;
        aux.w = NaN;
    end
    
    if logical(i)
        results.step.EKF_nlMPC = aux;
    else
        results.osc.EKF_nlMPC = aux;
    end
    clear aux;

    for j=1:length(NGs)
        % Library size
        n_g = NGs(j);
        for k=0:1
            % Operator retrieval
            if logical(k)
                load(sprintf(data_source+'EKF_covradial_ng_%i.mat',n_g));
                S0_EKF = Spline_Radial_Obs([0;0;eta;0;eta], X0);
            else
                load(sprintf(data_source+'EKF_radial_ng_%i.mat',n_g));
                S0_EKF = Spline_Radial_Obs([0;0], X0);
            end
            A_EKF = A(1:n_x,:);
            B_EKF = B(1:n_x,:);
            C_EKF = C;
            X0_EKF = X0;
            
            % Nonlinear MPC
            try
                simout = sim("Koopman_nlMPC.slx");
                aux.simout = simout;
                aux.RMSE = rmse(simout.X_hat,simout.states,1)';
                aux.x = simout.X';
                aux.x_hat = simout.X_hat';
                aux.w = simout.W';
            catch
                aux.simout = NaN;
                aux.RMSE = [NaN;NaN];
                aux.x = NaN;
                aux.x_hat = NaN;
                aux.w = NaN;
            end
            aux.n_g = n_g;
            if logical(i)
                if logical(k)
                    results.step.K_nlMPC.covradial{j} = aux;
                else
                    results.step.K_nlMPC.radial{j} = aux;
                end
            else
                if logical(k)
                    results.osc.K_nlMPC.covradial{j} = aux;
                else
                    results.osc.K_nlMPC.radial{j} = aux;
                end
            end
            clear aux;

            % Linear MPC
            try
                simout = sim("Koopman_lMPC.slx");
                aux.simout = simout;
                aux.RMSE = rmse(simout.X_hat,simout.states,1)';
                aux.x = simout.X';
                aux.x_hat = simout.X_hat';
                aux.w = simout.W';
            catch
                aux.simout = NaN;
                aux.RMSE = [NaN;NaN];
                aux.x = NaN;
                aux.x_hat = NaN;
                aux.w = NaN;
            end
            aux.n_g = n_g;
            if logical(i)
                if logical(k)
                    results.step.K_lMPC.covradial{j} = aux;
                else
                    results.step.K_lMPC.radial{j} = aux;
                end
            else
                if logical(k)
                    results.osc.K_lMPC.covradial{j} = aux;
                else
                    results.osc.K_lMPC.radial{j} = aux;
                end
            end
            clear aux;
        end
    end
end

save("results.mat","results");