function dxdt = vdp_CT0(x,u)
    dxdt = [2*x(2);
            -0.8*x(1)+2*x(2)-10*(x(1)^2)*x(2)+u];
end

