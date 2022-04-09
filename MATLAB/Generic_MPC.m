%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');

%% DC Motor - Parameters

R = 0.4; % 0.4 [Ohm]
L = 5e-2; % 50 [mH]
b = 0.01; % 10 [mN m / Rad]
K = 1.25; % 1.25 [V s / Rad]
J = 0.5; % 0.5 [Kg m²]

%% DC Motor - Model

A = [-b/J K/J
     -K/L -R/L];
B = [0
     1/L];
C = eye(2);
D = zeros(2,1);

DC_Motor = ss(A,B,C,D);

%% DC Motor - Naming and Units

DC_Motor.InputName = {'Voltage'};
DC_Motor.StateName = {'Angular Velocity',...
                        'Current'};
DC_Motor.OutputName = DC_Motor.StateName;

DC_Motor.InputUnit = {'V'};
DC_Motor.StateUnit = {'rad/s','A'};
DC_Motor.OutputUnit = DC_Motor.StateUnit;

%% DC Motor - MPC Parameters

DC_Motor = setmpcsignals(DC_Motor, 'MV', 1, 'MO', 2, 'UO', 1);
damp(DC_Motor);
step(DC_Motor);

old_status = mpcverbosity('off');
DC_Motor_MPC = mpc(DC_Motor, 0.1);