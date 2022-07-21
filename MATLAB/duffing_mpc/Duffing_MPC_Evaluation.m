%% Env Init

close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Thesis/Nonlinear_MPC_DUFF/";

%% Parameter selection

cov_is_state = false;
obs_type = "polynomial";
n_g = 19; % M->P in the case of polynomial bases

%% Operators' retrieval

% Load nlMPC
load(data_source+"duff_mpc_definitive.mat");

% load Koopman
if cov_is_state
    if strcmp(obs_type,"radial")
        load(sprintf(data_source+'kk_cov_radial_ng_%i.mat',n_g));
    elseif strcmp(obs_type,"polynomial")
        load(sprintf(data_source+'kk_cov_polynomial_P_%i.mat',n_g));
    end
else
    if strcmp(obs_type,"radial")
        load(sprintf(data_source+'kk_radial_ng_%i.mat',n_g));
    elseif strcmp(obs_type,"polynomial")
        load(sprintf(data_source+'kk_polynomial_P_%i.mat',n_g));
    end
end

A = A(1:n_x,:);
B = B(1:n_x,:);

%% Set simulation parameters

Tf = 100;
eta = 0.001;

load(data_source+"reference_duffing_oscillating");
R1 = array2timetable(R(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(R(2,:)',"TimeStep",seconds(Ts));

createParameterBus(nlobj, ...
    ['Simulink_DUFF_KalmanMPC' '/duffMPC'], ...
    'Ts_Bus',{Ts});

if cov_is_state
    x_0 = zeros(n_x,1);
    x_0(3) = eta;
    x_0(5) = eta;
    if strcmp(obs_type,"radial") 
        ss_0 = Spline_Radial_Obs(x_0,X0);
    elseif strcmp(obs_type,"polynomial")
        [ss_0,~,expts] = Poly_Obs(x_0,n_g);
    end
else
    x_0 = zeros(n_x,1);
    if strcmp(obs_type,"radial") 
        ss_0 = Spline_Radial_Obs(x_0,X0);
    elseif strcmp(obs_type,"polynomial") 
        [ss_0,~,expts] = Poly_Obs(x_0,n_g);
    end
end
u_0 = zeros(n_w,1);