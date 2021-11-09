function [Jrow, Jval] = stampJ_3_phase_cap(C, V1_node,Vprev,Ic_prev, delta_t)
%UNTITLED7 Summary of this function goes here


    
    Jrow = [];
    Jval = [];
    
    index = 0;

    for i=1:3
        

        Jrow(index+1) = V1_node(i);
        Jval(index+1) = -(Ic_prev(i) + 2*C*Vprev(V1_node(i))/delta_t;
        
        index = index+1;
        
    end
end

