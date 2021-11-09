function [Yrow, Ycol, Yval, Jrow, Jval] = stamp_3phase_series_inductor(L, V1_node,V2_node, Il_node, Vprev, delta_t)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    Yrow = [];
    Ycol = [];
    Yval = [];
    
    Jrow = [];
    Jval = [];
    
    index = 0;

    G = delta_t/(2*L);
    
    %stamp G series
    Grow, Gcol,Gval = stamp_3phase_resistance(1/G, V1_node, V2_node);
        
    Yrow = [Yrow, Grow];
    Ycol = [Ycol, Gcol];
    Yval = [Yval, Gval];
        
    
    for i=1:3
      

        Jrow(index+1) = V1_node(i);
        delta_Vl = Vprev(V1_node(i)) - Vprev(V2_node(i));
        Jval(index+1) = Il_prev(i) + delta_t*delta_Vl/(2*L);
        index = index+1;
        
        
    end

end

