function real_value = get_NRMSE(NRMSE,i)
    try
        real_value = NRMSE(i);
    catch
        real_value = NaN;
    end
end

