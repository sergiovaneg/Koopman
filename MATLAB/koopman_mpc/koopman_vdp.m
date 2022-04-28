function xk1 = koopman_vdp(xk,uk,X0,A,B)
    aux = vecnorm(X0-xk)';
    xk1 = A*[xk;aux.*log(aux.^aux)] + B*uk;
end