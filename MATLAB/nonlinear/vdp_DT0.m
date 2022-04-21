function xk1 = vdp_DT0(xk,uk,Ts)
    M = 100;
    delta = Ts/M;
    xk1 = xk;
    for ct=1:M
        xk1 = xk1+delta*vdp_CT0(xk,uk);
    end
end

