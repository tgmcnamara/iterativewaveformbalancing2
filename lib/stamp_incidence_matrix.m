function [a_row, a_col, a_val, a_idx] = stamp_incidence_matrix(linear_devices, nonlinear_devices)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    n_lin = size(linear_devices,2);
    n_nlin = size(nonlinear_devices,2);
    
    a_row = [];
    a_col  = [];
    a_val = [];
    a_idx = [];
    
    
    for n_l =1:n_lin
        lin_device = linear_devices(n_l);
        [ab_row, ab_col, ab_val, ab_idx] = lin_device.stampIncidenceMatrix();
       
        a_row = [a_row, ab_row];
        a_col = [a_col, ab_col];
        a_val = [a_val, ab_val];
        a_idx = a_idx+ab_idx;
        
    end


    for n_nl = 1:n_nlin
        
        nlin_device = nonlinear_devices(n_nl);
        [ab_row, ab_col, ab_val, ab_idx] = nlin_device.stampIncidenceMatrix();
        a_row = [a_row, ab_row];
        a_col = [a_col, ab_col];
        a_val = [a_val, ab_val];
        a_idx = a_idx+ab_idx;
        
    end
    
end

