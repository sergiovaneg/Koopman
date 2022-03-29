function [V,Lambda] = SVD_DMD(g)
    %SVD_DMD Summary of this function goes here
    %   Detailed explanation goes here
    X = g(:,1:end-1);
    Y = g(:,2:end);

    [U,S,Vp] = svd(X,'econ');
    A = U'*Y*Vp/S;
    [W,Lambda] = eig(A);
    V=U*W;
end