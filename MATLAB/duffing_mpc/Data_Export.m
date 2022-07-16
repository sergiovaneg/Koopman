%% Env Init

close all;
clc;

%% Directory Selection

data_source = "~/Documents/Thesis/Nonlinear_MPC_DUFF/";

%% Data extraction

X = [out.X_hat'; % Estimated States
    out.Gamma(1:2:end,1)'; % First State Variance
    out.Gamma(1:2:end,2)'; % State Covariance
    out.Gamma(2:2:end,2)' % Second State Variance
    ];
Y = out.Y'; % Measured System Output (Second State)
R = out.R'; % Reference to follow
W = out.W'; % Control signal
save(data_source + "data_duffing_definitive.mat","R","W","X","Y","Ts","out");