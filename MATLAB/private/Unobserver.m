function C = Unobserver(X_Lift,X)
    C0 = X*pinv(X_Lift);
    C = C0;
    
%     for i=1:size(X,1)
%         fun = @(c) X(i,:)-c*X_Lift;
%         c0 = C0(i,:);
%     
%         c = lsqnonlin(fun,c0);
%     
%         C(i,:) = c;
%     end
end

