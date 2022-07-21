%% Env Init

close all;
clearvars;
clc;
addpath("../");
rng('default');
data_source = "~/Documents/Thesis/Nonlinear_MPC_DUFF/";

%% Parameter selection

cov_is_state = false;
obs_type = "polynomial";
n_g = 19; % M->P in the case of polynomial bases

%% First step - System observation

load(data_source + "data_duffing_definitive.mat");
L = size(Y,2)-1;

if ~cov_is_state
    X = X(1:2,:);
end
n_x = size(X,1);
n_w = size(W,1);

if strcmp(obs_type,"radial")
    X0 = zeros(size(X,1),n_g);
    for i=1:size(X0,1)
        X0(i,:) = random('Normal',mean(X(i,:)),std(X(i,:)),1,n_g);
    end
    [G,~] = Spline_Radial_Obs(X,X0);
    G1 = G(:,1:L);
    G2 = G(:,2:L+1);
    
elseif strcmp(obs_type,"polynomial")
    [G,~,expts] = Poly_Obs(X,n_g);
    G1 = G(:,1:L);
    G2 = G(:,2:L+1);
end
U = [R(:,2:L+1);
    Y(:,2:L+1);
    W(:,1:L)]; % For control as output

%% Second step - Operator calculation

tic

alpha = 1e-3;
[A,B] = Koopman(G1,G2,U,alpha,size(G2,1));
[C,D] = Koopman(G2,W(:,2:L+1),U,alpha,size(W,1));

if cov_is_state
    if strcmp(obs_type,"radial")
        save(sprintf(data_source+'kk_cov_radial_ng_%i.mat',n_g), ...
            "A","B","C","D","Ts","X0","n_x","n_w");
    elseif strcmp(obs_type,"polynomial")
        save(sprintf(data_source+'kk_cov_polynomial_P_%i.mat',n_g), ...
            "A","B","C","D","Ts","n_x","n_w","expts");
    end
else
    if strcmp(obs_type,"radial")
        save(sprintf(data_source+'kk_radial_ng_%i.mat',n_g), ...
            "A","B","C","D","Ts","X0","n_x","n_w");
    elseif strcmp(obs_type,"polynomial")
        save(sprintf(data_source+'kk_polynomial_P_%i.mat',n_g), ...
            "A","B","C","D","Ts","n_x","n_w","expts");
    end
end

toc

Lambda = eig(A);
figure(1);
scatter(real(Lambda),imag(Lambda));
hold on;
rectangle('Position', [-1 -1 2 2], 'Curvature', 1);
hold off;