function [y_row, y_col, y_val, y_idx] = stamp_BCR_matrix(linear_devices, nonlinear_devices, delta_t)

    y_row =[];
    y_col = [];
    y_val = [];
    y_idx = 0;
    
    n_lin = length(linear_devices);
    n_nlin = length(nonlinear_devices);
   
    for n_l=1:n_lin
        
        lin_device = linear_devices(n_l);
        
        [yl_row, yl_col, yl_val] = lin_device.stamp_BCRlinear_matrix(delta_t);
        
        % y_row = [y_row, yl_row + y_idx];
        y_row = [y_row, yl_row];
        y_col = [y_col, yl_col];
        y_val = [y_val, yl_val];
        
        % y_idx = y_idx + yl_idx;
        
    end
    
    for n_nl=1:n_nlin
        nonlin_device = nonlinear_devices(n_nl);
        [yl_row, yl_col, yl_val] = nonlin_device.stamp_BCR_Y();
        y_row = [y_row, yl_row];
        y_col = [y_col, yl_col];
        y_val = [y_val, yl_val];
    end


end

