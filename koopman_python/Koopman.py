#!/usr/bin/python3

from cmath import inf
import numpy as np
from docplex.mp.model import Model
import glob

import csv

data_source = "/home/sergiovaneg/Documents/Thesis/Python_Data/";

X=[];
Y=[];
U=[];
for filename in glob.glob(data_source + "Input_*.csv"):
    with open(filename) as csvfile:
        csv_reader = csv.reader(csvfile);
        for row in csv_reader:
            U.append(list(map(np.double, row[1:])));
        U.pop()
U = np.concatenate(U);
for filename in glob.glob(data_source + "Output_*.csv"):
    with open(filename) as csvfile:
        aux = [];
        csv_reader = csv.reader(csvfile);
        for row in csv_reader:
            aux.append(list(map(np.double, row[1:])));
        X.append(np.array(aux[:-1]));
        Y.append(np.array(aux[1:]));
X = np.concatenate(X);
Y = np.concatenate(Y);

mdl = Model('my_test');
aux = mdl.infinity;
coeffs = [1,2,3];
x = mdl.continuous_var_list(range(3),0, None, 'x');

mdl.set_objective('min',mdl.sumsq((x[i]-coeffs[i]) for i in range(3)) + 0.001*mdl.sumsq(x));
mdl.solve();
mdl.print_solution();