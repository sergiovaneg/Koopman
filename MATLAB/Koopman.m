function [A,B] = Koopman(X,Y,U,alpha,nx)
    % Following "Practical Considerations" from Korda-Mezić + Williams
    K = size(X,2);

    G = [X/K;U/K]*[X;U]';
    V = (Y(1:nx,:)/K)*[X;U]';
    
    A = zeros(nx,size(X,1));
    B = zeros(nx,size(U,1));

    for i=1:nx
        m0 = V(i,:)/G;
        
        if alpha>0.0
            cvx_begin
                variable m(size(m0))
                minimize (norm((m*[X;U]-Y(i,:))/K) + alpha*norm(m)/K)
            cvx_end
        elseif alpha==0.0
            m = m0;
        end

        A(i,:) = m(1:size(X,1));
        B(i,:) = m(size(X,1)+1:end);
    end
end