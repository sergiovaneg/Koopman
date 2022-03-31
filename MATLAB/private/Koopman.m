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
        m0 = V(i,:)/G;

%         m = lsqnonlin(fun,m0);

        A(i,:) = m0(1:size(X,1));
        B(i,:) = m0(size(X,1)+1:end);
    end
end