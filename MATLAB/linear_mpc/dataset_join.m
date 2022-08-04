close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Thesis/Linear_MPC/";

system("rm "+data_source+"Data_joint.mat");
files = dir(data_source+"Data_*.mat");

load(data_source+files(1).name,'z','ts');
Ts=ts;
aux = z;
for i=2:length(files)
    load(data_source+files(i).name,'z');
    aux = [aux z(:,2:end)];
end
R1 = array2timetable(aux(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(aux(2,:)',"TimeStep",seconds(Ts));
save(data_source+"Data_joint.mat","R1","R2");