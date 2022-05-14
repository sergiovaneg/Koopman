# Koopman operator for Kalman-informed non-linear MPC

In this repository, you will find the source code used for the Koopman
identification algorithm applied to a Kalman-MPC control scheme; specifically,
the current implementation is applied to a Forced Van der Pol oscillator.

In the 'MATLAB' directory, you will find most of the early code, as well as the
'Koopman' function used to identify the Koopman matrix projections and the
open-loop simulation script. Furthermore, in the same directory you will find
yet another subdirectory named 'nonlinear_mpc', which has the VDP specific
files and Simulink models.
