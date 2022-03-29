function [g,n] = Poly_Obs(z,P)
    %POLYOBS Summary of this function goes here
    %   Detailed explanation goes here
    Nx = size(z,1);
    K = size(z,2);
    n = factorial(Nx+P)/(factorial(Nx)*factorial(P));
    g = ones(n,K);
    
    exponents = zeros(n,Nx);
    current = zeros(1,Nx);

    [exponents,~] = Recursive_Monomial(1,1,exponents,current,P);

    for i=1:n
        for j=1:Nx
            g(i,:) = g(i,:).*(z(j,:).^exponents(i,j));
        end
    end
end