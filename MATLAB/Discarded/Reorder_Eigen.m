function [V_o,L_o] = Reorder_Eigen(V_t,L_t,L)
    L = diag(L);
    L_t = diag(L_t);
    
    dist = zeros(length(L));
    pairs = zeros(length(L));
    order=zeros(size(L));
    for i=1:length(L)
        for j=1:length(L)
            diff = L(i)-L_t(j);
            dist(i,j) = diff*conj(diff);
        end
        [~,pairs(i,:)] = sort(dist(i,:),"ascend");
        order(i) = pairs(i,1);
    end

    V_o = V_t(:,order);
    L_o = diag(L_t(order));
end

