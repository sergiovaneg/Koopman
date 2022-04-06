%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/";

%% Data Read

U_cpp = readmatrix(Data_Source + "Cpp_Data/Input_0.csv");
X_cpp = readmatrix(Data_Source + "Cpp_Data/Output_0.csv");
    
U_rust = readmatrix(Data_Source + "Rust_Data/input_0.csv");
T_rust = readmatrix(Data_Source + "Rust_Data/time_0.csv");
X_rust = readmatrix(Data_Source + "Rust_Data/states_0.csv");

U_python = readmatrix(Data_Source + "Python_Data/Input_0.csv");
X_python = readmatrix(Data_Source + "Python_Data/Output_0.csv");

%% MATLAB Simulation

[~,z_cpp] = ode45(@(t,z) VanDerPol(t,z,U_cpp(:,1),U_cpp(:,2)), ...
                U_cpp(:,1), ...
                X_cpp(1,2:3));

[~,z_rust] = ode45(@(t,z) VanDerPol(t,z,T_rust(:,1),U_rust(:,1)), ...
                T_rust(:,1), ...
                X_rust(1,:));

[~,z_python] = ode45(@(t,z) VanDerPol(t,z,U_python(:,1),U_python(:,2)), ...
                U_python(:,1), ...
                X_python(1,2:3));

%% Data Plot

figure(1);
title("C++ data");
scatter(z_cpp(:,1), z_cpp(:,2));
hold on;
scatter(X_cpp(:,2), X_cpp(:,3));
legend("MATLAB simulation", "CPP simulation");
hold off;

figure(2);
title("Rust data");
scatter(z_rust(:,1), z_rust(:,2));
hold on;
scatter(X_rust(:,1), X_rust(:,2));
legend("MATLAB simulation", "Rust simulation");
hold off;

figure(3);
title("Python data");
scatter(z_python(:,1), z_python(:,2));
hold on;
scatter(X_python(:,2), X_python(:,3));
legend("MATLAB simulation", "Python simulation");
hold off;