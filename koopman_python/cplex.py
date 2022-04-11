from cmath import inf
from docplex.mp.model import Model

mdl = Model(name='vector')
mdl.continuous_var_list(range(3), name='coefficient', lb=-inf);