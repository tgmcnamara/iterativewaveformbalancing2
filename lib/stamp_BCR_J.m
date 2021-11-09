function [j_row, j_val, j_idx] = stamp_BCR_J(t_ind, delta_t, buses, linear_devices, nonlinear_devices, Ibranch, Vbranch)


    j_row = [];
    j_val = [];
    j_idx = 0;
    
    n_lin = length(linear_devices);
    n_nlin = length(nonlinear_devices);


    for n_l = 1:n_lin
        
        lin_device = linear_devices(n_l);
        [jlin_row, jlin_val] = lin_device.stamp_BCR_J(delta_t, Ibranch, Vbranch);
        % why do we need to shift by index? we dont need to track index 
        j_row = [j_row, jlin_row + j_idx];
        j_val = [j_val, jlin_val];
        %j_idx = j_idx + jlin_idx;
        
    end
    
    for n_nl = 1:n_nlin
        
        nlin_device = nonlinear_devices(n_nl);
        [jnlin_row, jnlin_val] = nlin_device.stamp_BCR_J(t_ind);
        
        j_row = [j_row, jnlin_row];
        j_val = [j_val, jnlin_val];
        %j_idx = j_idx + jnlin_idx;
        
    end
    
    
end

