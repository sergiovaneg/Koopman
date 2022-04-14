%% Env Init

close all;
clearvars;
clc;
rng(0,'threefry');
Data_Source = "~/Documents/Thesis/VanDerPol_Unsteady_Input/";

%% Operator retrieval

K = 100;
M = 5:5:30;
Alpha = 4:-1:0;
load(Data_Source+'Radial/Operator_M_5_alpha_none.mat',"ts");

Normalized_Error = zeros(length(M),1+length(Alpha),3);

%% Trajectory generation

T = 1.;
sigma = randn(1);
u_t = 0.:ts:T;

% Constant Input
u = 0.*u_t;
for m_idx=1:length(M)
    for k=1:K
        load(sprintf(Data_Source+ ...
                    "Radial/Operator_M_%i_alpha_none.mat", ...
                    M(m_idx)));
        z0 = 2*rand(2,1) - 1;
        [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
        z = z';
        L = length(0:ts:T);
        z_norm = norm(z);

        g_p = zeros(size(B,1),L);
        [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
        for i=1:L-1
            g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
        end
        z_p = C*g_p;
        error_norm = norm(z_p-z);

        Normalized_Error(m_idx,1,1) =...
            Normalized_Error(m_idx,1,1)+error_norm/(K*z_norm);
    end

    for alpha_idx=1:length(Alpha)
        load(sprintf(Data_Source+ ...
                        "Radial/Operator_M_%i_alpha_%i.mat", ...
                        M(m_idx),Alpha(alpha_idx)));
        for k=1:K
            z0 = 2*rand(2,1) - 1;
            [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
            z = z';
            L = length(0:ts:T);
            z_norm = norm(z);

            g_p = zeros(size(B,1),L);
            [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
            for i=1:L-1
                g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
            end
            z_p = C*g_p;
            error_norm = norm(z_p-z);

            Normalized_Error(m_idx,alpha_idx+1,1) =...
                Normalized_Error(m_idx,alpha_idx+1,1)+error_norm/(K*z_norm);
        end
    end
end

% Sine Input
u = sin(4*pi*u_t);
for m_idx=1:length(M)
    for k=1:K
        load(sprintf(Data_Source+ ...
                    "Radial/Operator_M_%i_alpha_none.mat", ...
                    M(m_idx)));
        z0 = 2*rand(2,1) - 1;
        [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
        z = z';
        L = length(0:ts:T);
        z_norm = norm(z);

        g_p = zeros(size(B,1),L);
        [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
        for i=1:L-1
            g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
        end
        z_p = C*g_p;
        error_norm = norm(z_p-z);

        Normalized_Error(m_idx,1,2) =...
            Normalized_Error(m_idx,1,2)+error_norm/(K*z_norm);
    end

    for alpha_idx=1:length(Alpha)
        load(sprintf(Data_Source+ ...
                        "Radial/Operator_M_%i_alpha_%i.mat", ...
                        M(m_idx),Alpha(alpha_idx)));
        for k=1:K
            z0 = 2*rand(2,1) - 1;
            [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
            z = z';
            L = length(0:ts:T);
            z_norm = norm(z);

            g_p = zeros(size(B,1),L);
            [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
            for i=1:L-1
                g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
            end
            z_p = C*g_p;
            error_norm = norm(z_p-z);

            Normalized_Error(m_idx,alpha_idx+1,2) =...
                Normalized_Error(m_idx,alpha_idx+1,2)+error_norm/(K*z_norm);
        end
    end
end

% Square Input
u = sign(u);
for m_idx=1:length(M)
    for k=1:K
        load(sprintf(Data_Source+ ...
                    "Radial/Operator_M_%i_alpha_none.mat", ...
                    M(m_idx)));
        z0 = 2*rand(2,1) - 1;
        [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
        z = z';
        L = length(0:ts:T);
        z_norm = norm(z);

        g_p = zeros(size(B,1),L);
        [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
        for i=1:L-1
            g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
        end
        z_p = C*g_p;
        error_norm = norm(z_p-z);

        Normalized_Error(m_idx,1,3) =...
            Normalized_Error(m_idx,1,3)+error_norm/(K*z_norm);
    end

    for alpha_idx=1:length(Alpha)
        load(sprintf(Data_Source+ ...
                        "Radial/Operator_M_%i_alpha_%i.mat", ...
                        M(m_idx),Alpha(alpha_idx)));
        for k=1:K
            z0 = 2*rand(2,1) - 1;
            [t,z] = ode45(@(t,z) VanDerPol(t,z,u_t,u), u_t, z0);
            z = z';
            L = length(0:ts:T);
            z_norm = norm(z);

            g_p = zeros(size(B,1),L);
            [g_p(:,1),~] = Spline_Radial_Obs(z(:,1),X0);
            for i=1:L-1
                g_p(:,i+1) = A*g_p(:,i) + B*u(:,i);
            end
            z_p = C*g_p;
            error_norm = norm(z_p-z);

            Normalized_Error(m_idx,alpha_idx+1,3) =...
                Normalized_Error(m_idx,alpha_idx+1,3)+error_norm/(K*z_norm);
        end
    end
end

%% Percentage representation

Percentual_Error_Steady = array2table(100*Normalized_Error(:,:,1), ...
    "VariableNames",["0",string(10.^-Alpha)], ...
    "RowNames",string(M), ...
    "DimensionNames",["M","Alpha"]);
Percentual_Error_Sine = array2table(100*Normalized_Error(:,:,2), ...
    "VariableNames",["0",string(10.^-Alpha)], ...
    "RowNames",string(M), ...
    "DimensionNames",["M","Alpha"]);
Percentual_Error_Square = array2table(100*Normalized_Error(:,:,3), ...
    "VariableNames",["0",string(10.^-Alpha)], ...
    "RowNames",string(M), ...
    "DimensionNames",["M","Alpha"]);

writetable(Percentual_Error_Steady, ...
    sprintf(Data_Source+"table_steady_T_%.2f.csv",T), ...
    "WriteRowNames",true);
writetable(Percentual_Error_Sine, ...
    sprintf(Data_Source+"table_sine_T_%.2f.csv",T), ...
    "WriteRowNames",true);
writetable(Percentual_Error_Square, ...
    sprintf(Data_Source+"table_square_T_%.2f.csv",T), ...
    "WriteRowNames",true);