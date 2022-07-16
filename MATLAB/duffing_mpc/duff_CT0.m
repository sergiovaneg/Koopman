function dxdt = duff_CT0(x,u)
    dxdt = [x(2);
            (x(1)-x(1)^3)-0.5*x(2)+u];
end

