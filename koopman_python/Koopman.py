#!/usr/bin/python3

from cmath import inf
from docplex.mp.model import Model


mdl = Model('my_test');

x = mdl.continuous_var(0, None, 'x');
y = mdl.integer_var(0, None, 'y');
z = mdl.binary_var('z');

mdl.add(x**2 >= 1);
mdl.add(y**2 >= 2);
mdl.add(z**2+y**2 <= 5);

obj_fun = x**2 + y**2 + z**2;
mdl.set_objective('min', obj_fun);

mdl.print_information();
mdl.solve();
mdl.print_solution();

mdl.add(z**2 + y**2 <= x**2);
mdl.solve();
mdl.print_solution();