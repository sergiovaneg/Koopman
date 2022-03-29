function [V,Lambda,Chi] = Exact_DMD(g)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    X = g(:,1:end-1);
    Y = g(:,2:end);

    [U,S,Vp] = svd(X,'econ');
    A = conj(U)'*Y*Vp/S;    
    [W,Lambda] = eig(A);
    V = (Y*Vp/S)*(W/Lambda);
    Chi = U*W;
end

