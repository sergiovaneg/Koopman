import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import os,sys

n = 100

period = 20.0
ts = 0.01

def VanDerPol(t,y,u):
    ydot = np.zeros(y.shape)
    aux = u(t)

    ydot[0] = 2.*y[1]
    ydot[1] = -0.8*y[0] + 2.*y[1] - 10.*(y[0]**2)*y[1] + aux

    return ydot

dir = "/home/sergiovaneg/Documents/Thesis/Python_Data/"
if not os.path.exists(dir):
    os.makedirs(dir)

K = int(period/ts) + 1;
u_t = np.linspace(0,period,K)

for i in range(n):
    x0 = np.random.uniform(-1.,1.,2)

    u = np.random.normal(0.,1.,len(u_t))
    u_int = interp1d(u_t,u);
    with open(dir+"Input_"+str(i)+".csv",'w') as f:
        for j in range(len(u_t)):
            print(str(u_t[j])+","+str(u_int(u_t[j])), file=f)
            

    sol = solve_ivp(fun=VanDerPol,
                        y0=x0,
                        t_span=(0,period),
                        method='RK45',
                        t_eval=u_t,
                        vectorized=True,
                        args=(u_int,),
                        dense_output=True
    )
    t = sol.t;
    x = sol.y;

    with open(dir+"Output_"+str(i)+".csv",'w') as f:
        for j in range(len(t)):
            print(str(t[j])+",",file=f,end="")
            for k in range(len(x0)):
                print(str(x[k,j])+",",file=f,end="")
            print(file=f)