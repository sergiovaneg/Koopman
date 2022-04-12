#!/usr/bin/python3

from cmath import inf
import numpy as np
from docplex.mp.model import Model


mdl = Model('my_test');
aux = mdl.infinity;
coeffs = [1,2,3];
x = mdl.continuous_var_list(range(3),0, None, 'x');

mdl.set_objective('min',mdl.sumsq((x[i]-coeffs[i]) for i in range(3)) + 0.001*mdl.sumsq(x));
mdl.solve();
mdl.print_solution();