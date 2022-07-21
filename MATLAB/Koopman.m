function [A,B] = Koopman(X,Y,U,alpha,n_x)
    % Following "Practical Considerations" from Korda-Mezić + Williams
    K = size(X,2);

    G = [X;U]*[X;U]'/K;
    V = Y(1:n_x,:)*[X;U]'/K;
    M0 = V*pinv(G);
    
    A = zeros(n_x,size(X,1));
    B = zeros(n_x,size(U,1));

    for i=1:n_x
        if alpha>0.0
            fprintf("Iteration: %i out of %i\n",i,n_x);
            cvx_begin
                variable m(1,size(X,1)+size(U,1))
                minimize (norm((m*[X;U]-Y(i,:)))/sqrt(K) ...
                    + alpha*norm(m)/sqrt(length(m)))
            cvx_end
        elseif alpha==0.0
            m = M0(i,:);
        end

        A(i,:) = m(1:size(X,1));
        B(i,:) = m(size(X,1)+1:end);
    end
end 