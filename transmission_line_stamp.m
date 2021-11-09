function [Yrow,Ycol,Yval, Jrow,Jval] = transmission_line_stamp(delta_t,Y, V1_node, V2_node, Vx_node, Il_node,Vprev, Ic_prev, branch_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    Rseries = branch_data(3);
    Lseries = branch_data(4);
    Cshunt = branch_data(5);
    
    Yrow = [];
    Ycol = [];
    Yval = [];
    
    Jrow = [];
    Jval = [];
    
    Yres_row, Yres_col, Yres_val = stamp_3phase_resistance(Rseries, V1_node, Vx_node);
    
    Yc1_row, Yc1_col, Yc1_val, Jc1_row, Jc1_val = stamp_3_phase_cap(Cshunt, V1_node,Vprev,Ic_prev, delta_t);

    Yc2_row, Yc2_col, Yc2_val, Jc2_row, Jc2_val = stamp_3_phase_cap(Cshunt, V2_node,Vprev,Ic_prev, delta_t);

    Yl_row, Yl_col, Yl_val, Jl_row, Jl_val = stamp_3phase_series_inductor(
    
end

