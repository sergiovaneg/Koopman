function [g,n] = Spline_Radial_Obs(z,X0)
    L = size(z,2);
    n = size(X0,1);
    N = size(X0,2);

    % Preservation of original states
    g = [z;zeros(N,L)];

    for i=1:N
        x0 = X0(:,i);
        g(i+n,:) = vecnorm(z-x0,2,1).*log(vecnorm(z-x0,2,1).^vecnorm(z-x0,2,1));    
    end

    n=n+N;
end