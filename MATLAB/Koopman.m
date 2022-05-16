function [A,B] = Koopman(X,Y,U,alpha,nx)
    % Following "Practical Considerations" from Korda-Mezić + Williams
    K = size(X,2);

    G = [X;U]*[X;U]'/K;
    G_pinv = pinv(G);
    V = Y(1:nx,:)*[X;U]'/K;
    
    A = zeros(nx,size(X,1));
    B = zeros(nx,size(U,1));

    for i=1:nx
        m0 = V(i,:)*G_pinv;
        
        if alpha>0.0
            cvx_begin
                variable m(1,size(X,1)+size(U,1))
                minimize (norm((m*[X;U]-Y(i,:)))/K + alpha*norm(m)/length(m))
            cvx_end
        elseif alpha==0.0
            m = m0;
        end

        A(i,:) = m(1:size(X,1));
        B(i,:) = m(size(X,1)+1:end);
    end
end