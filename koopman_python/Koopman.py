#!/usr/bin/python3

import numpy as np
from docplex.mp.model import Model
from scipy.io import loadmat,savemat

"""
import csv
import glob

X,Y,U=[],[],[]
for filename in glob.glob(dataSource + "Input_*.csv"):
    with open(filename) as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            U.append(list(map(np.double, row[1:])))
        U.pop()
U = np.concatenate(U);
for filename in glob.glob(dataSource + "Output_*.csv"):
    with open(filename) as csvfile:
        aux = [];
        csv_reader = csv.reader(csvfile);
        for row in csv_reader:
            aux.append(list(map(np.double, row[1:])))
        X.append(np.array(aux[:-1]))
        Y.append(np.array(aux[1:]))
X = np.concatenate(X)
Y = np.concatenate(Y)
"""

dataSource = "/home/sergiovaneg/Documents/Thesis/Python_Data/"

mlData = loadmat(dataSource+"input.mat")
Px,Py,U = mlData['Px'],mlData['Py'],mlData['U']

alpha = 1.e-3;
A = np.zeros((len(Py),len(Px)))
B = np.zeros((len(Py),len(U)))

for i in range(len(Py)):
    mdl = Model('Koopman')
    mdl.log_output = True

    a = mdl.continuous_var_list(range(len(Px)),-mdl.infinity,None,'a')
    b = mdl.continuous_var_list(range(len(U)),-mdl.infinity,None,'b')
    mdl.set_objective('min',
        mdl.sumsq((Py[i,j]-sum(a[k]*Px[k,j] for k in range(len(Px)))-sum(b[k]*U[k,j] for k in range(len(U))))/len(Py[i])
            for j in range(len(Py[i])))
        + alpha*(mdl.sumsq(a)+mdl.sumsq(b))/len(Py[i]))

    mdl.solve()
    mdl.print_solution()
    A[i] = a
    B[i] = b

mDic = {"A": A, "B": B}
savemat(dataSource + "output.mat", mDic)