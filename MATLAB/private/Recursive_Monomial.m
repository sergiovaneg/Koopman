function [exponents,i] = Recursive_Monomial(i,j,exponents,current,P)
    while sum(current) <= P
        if j==size(exponents,2) && sum(current)>0
            exponents(i,:) = current;
            i = i+1;
        else
            [exponents,i] = Recursive_Monomial(i,j+1,exponents,current,P);
        end
        current(j) = current(j)+1;
    end
    current(j) = 0;
end

