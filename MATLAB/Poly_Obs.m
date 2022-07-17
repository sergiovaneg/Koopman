function [g,n,exponents] = Poly_Obs(z,P)
    %POLYOBS Summary of this function goes here
    %   Detailed explanation goes here
    Nx = size(z,1);
    K = size(z,2);
    n = factorial(Nx+P)/(factorial(Nx)*factorial(P))-1;
    g = ones(n,K);
    
    exponents = [eye(Nx);
                zeros(n-Nx,Nx)];
    current = zeros(1,Nx);
    
    [exponents,~] = Recursive_Monomial(Nx+1,1,exponents,current,P);
    for i=1:n
        for j=1:Nx
            g(i,:) = g(i,:).*(z(j,:).^exponents(i,j));
        end
    end
end