function [V,Lambda] = CM_DMD(g,n)
    %CM_DMD Returns the n most significative EigenV/DynMode pairs
    %   Detailed explanation goes here
    X = g(:,1:end-1);
    Dm = g(:,end);
    L = size(g,2)-1;
    C = [[zeros(1,L-1);eye(L-1)],pinv(X)*Dm];

    % Post-evaluation of largest eigenvalues
%     [W,Lambda] = eig(C);
%     eigVs = diag(Lambda);
%     [~,I] = maxk(eigVs,n);
%     Lambda = Lambda(I,I);
%     V=X*W(:,I);   
    
    % Pre-selection largest eigenvalues
    [W,Lambda] = eigs(C,n,'largestabs', ...
        'MaxIterations',5e4,'FailureTreatment','drop','Tolerance',1e-3);
    V=X*W;
end

