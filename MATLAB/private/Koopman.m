function [A,B] = Koopman(X,Y,U,alpha)
    % Following "Practical Considerations" from Korda-Mezić + Williams
    K = size(X,2);

    G = [X/K;U/K]*[X;U]';
    V = (Y/K)*[X;U]';
    
    A = zeros(size(Y,1),size(X,1));
    B = zeros(size(Y,1),size(U,1));

%     Matricial division segmented because of memory limits
%     M0 = V/G;
%     A = M0(:,1:size(X,1));
%     B = M0(:,size(X,1)+1:end);
    
    options = optimoptions(@fminunc, ...
                        'Display', 'final', ...
                        'UseParallel', true);
    for i=1:size(Y,1)
        fprintf("\tCurrent observable: %i\n",i);
        m0 = V(i,:)/G;

%         m = lsqr([X;U]',Y(i,:)',[],[],[],[],m0')';
        
        if alpha>0.0
%             fun = @(m) sum((Y(i,:)-m*[X;U]).^2) ...
%                     + alpha*sum(m.^2);
%         
%             m = fminunc(fun,m0,options);
            cvx_begin
                variable m(len(m0))
                
            cvx_end
        elseif alpha==0.0
            m = m0;
        end

        A(i,:) = m(1:size(X,1));
        B(i,:) = m(size(X,1)+1:end);
    end
end