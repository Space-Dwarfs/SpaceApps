function [values,select] = excludeNaN(A)

    select = ~isnan(A) ;
    values = A(select) ;
    
end