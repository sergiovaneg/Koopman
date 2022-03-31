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

    for i=1:size(Y,1)
%         fun = @(m) sqrt((Y(i,:)-m*[X;U]).^2 ...
%                         +(alpha/K)*norm(m,"fro")^2);
        fun = @(m) (Y(i,:)-m*[X;U])*(Y(i,:)-m*[X;U])' ...
                + alpha*norm(m,"fro");
        m0 = V(i,:)/G;

%         m = lsqnonlin(fun,m0);
        options = optimset('Display','final');
        m = fminsearch(fun,m0,options);

        A(i,:) = m(1:size(X,1));
        B(i,:) = m(size(X,1)+1:end);
    end
end