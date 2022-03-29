function dxdt = VanDerPol(t,x,u_t,u)
    %VanDerPol Summary of this function goes here
    %   Detailed explanation goes here

    % x1' = 2*x2
    % x2' = -0.8*x1 + 2*x2 - 10*(x1^2)*x2 + u2

    u = interp1(u_t,u,t);
    dxdt = [2*x(2);
            -0.8*x(1)+2*x(2)-10*(x(1)^2)*x(2) + u];
end