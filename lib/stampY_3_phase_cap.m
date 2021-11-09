function [Yrow, Ycol, Yval, Jrow, Jval] = stampY_3_phase_cap(C, V1_node, delta_t)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    Yrow = [];
    Ycol = [];
    Yval = [];
    
    Jrow = [];
    Jval = [];
    
    index = 0;

    for i=1:3
        
        Yrow(index+1) = V1_node(i);
        Ycol(index+1) = V1_node(i);
        Yval(index+1) = 2*C/delta_t;
    
%         Jrow(index+1) = V1_node(i);
%         Jval(index+1) = -(Ic_prev(i) + 2*C*Vprev(V1_node(i))/delta_t;
        
        index = index+1;
        
    end
    


end

