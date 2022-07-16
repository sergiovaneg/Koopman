function xk1 = duff_DT0(xk,uk,Ts)
    M = 10;
    delta = Ts/M;
    xk1 = xk;
    for ct=1:M
        xk1 = xk1+delta*duff_CT0(xk1,uk);
    end
end

