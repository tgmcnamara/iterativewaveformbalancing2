function [row, col, val] = stamp_3phase_resistance(R,V1_node, V2_node)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    row = [];
    col = [];
    val = [];
    
    index = 0;
    
    G = 1/R;
    
    for i=1:3
        
        row(index+1) = V1_node(i);
        col(index+1) = V1_node(i);
        val(index+1) = G;
        index = index+1;
           
        row(index+1) = V1_node(i);
        col(index+1) = V2_node(i);
        val(index+1) = -G;
        index = index+1;
        
        row(index+1) = V2_node(i);
        col(index+1) = V2_node(i);
        val(index+1) = G;
        index = index+1;
           
        row(index+1) = V2_node(i);
        col(index+1) = V1_node(i);
        val(index+1) = -G;
        index = index+1;  
        
    end
    

end

