function [newV,newLambda] = Update_Eigen(V,Lambda,Vt,Lambdat,epsilon)
    %UPDATE_EIGEN Summary of this function goes here
    %   Detailed explanation goes here
    newV = (1-epsilon)*V;
    newLambda = (1-epsilon)*Lambda;
    Lambda = diag(Lambda);
    Lambdat = diag(Lambdat);
    
    n = length(Lambda);
    idx = ones(n,1);
    order=zeros(n,1);
    ordered = zeros(n,1,'logical');
    dist = zeros(n);
    pairs = zeros(n);
    for i=1:length(Lambda)
        for j=1:length(Lambda)
            diff = Lambda(i)-Lambdat(j);
            dist(i,j) = diff*conj(diff);
        end
        [dist(i,:),pairs(i,:)] = sort(dist(i,:),"ascend");
        order(i) = pairs(i,idx(i));
    end

    if n ~= length(unique(order))
        while all(ordered) ~= true
            for i=1:n
                if numel(ordered(order==order(i))) == 1
                    ordered(order==order(i)) = true;
                else
                    ordered(order==order(i)) = false;
                    for j=i+1:n
                        if order(i)==order(j)
                            if dist(i,idx(i)) < dist(j,idx(j))
                                idx(j) = idx(j)+1;
                                order(j) = pairs(j,idx(j));
                            else
                                idx(i) = idx(i)+1;
                                order(i) = pairs(i,idx(i));
                            end
                        end
                    end
                end
            end
        end
    end

    newV = newV + epsilon*Vt(:,order);
    newLambda = newLambda + epsilon*diag(Lambdat(order));
end

