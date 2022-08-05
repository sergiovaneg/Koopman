close all;
clearvars;
clc;
addpath("../");
data_source = "~/Documents/Thesis/Linear_MPC/";

system("rm "+data_source+"data_joint.mat");
files = dir(data_source+"Data_*.mat");

load(data_source+files(1).name,'z','ts','u');
Ts=ts;
aux = [z;u];
for i=2:length(files)
    load(data_source+files(i).name,'z','u');
    aux = [aux [z(:,2:end);u(:,1:end-1)]];
end
R1 = array2timetable(aux(1,:)',"TimeStep",seconds(Ts));
R2 = array2timetable(aux(2,:)',"TimeStep",seconds(Ts));
X = aux(1:2,:);
U = aux(3,:);
save(data_source+"data_joint.mat",'R1',"R2",'Ts','X','U');