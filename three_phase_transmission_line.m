classdef three_phase_transmission_line
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Rseries = 0;
        Cshunt = 0;
        Lseries = 0;
        prev_Icshunt1 = 0;
        prev_Icshunt2 = 0;
        prev_Vl = 0;
        Vfrom_node=[-1,-1,-1];;
        Vto_node = [-1,-1,-1];
        Vx_node = [-1,-1,-1];
        Il_node = [-1,-1,-1];
        from_bus = 0;
        to_bus = 0;
    end
    
    methods
        function obj = three_phase_transmission_line(from_bus, to_bus, Rseries, Cshunt, Lseries)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Rseries = Rseries;
            obj.Cshunt =Cshunt;
            obj.Lseries = Lseries;
            obj.from_bus = from_bus;
            obj.to_bus = to_bus;
        end
        
        function [obj,node_idx] = initialize_nodes(obj, node_idx, from_bus_obj, to_bus_obj)
            obj.Vfrom_node = from_bus_obj.V_node;
            obj.Vto_node = to_bus_obj.V_node;
            obj.Vx_node = [node_idx+1, node_idx+2, node_idx+3];
            obj.Il_node = [node_idx+4, node_idx+5, node_idx+6];
            node_idx = node_idx+6;

        end
        
        function obj = initialize_prev_values(obj, prev_Icshunt1, prev_Icshunt2,prev_Vl)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.prev_Icshunt1 = prev_Icshunt1;
            obj.prev_Icshunt2 = prev_Icshunt2;
            obj.prev_Vl = prev_Vl;
        end
        
        function [Yrow, Ycol, Yval] = stamp_Ylin(obj, delta_t)
           
            
            Yrow = [];
            Ycol = [];
            Yval = [];
            
            
            %%%STAMP Shunt CAPACITORs:
            [Yc1row, Yc1col, Yc1val] = stampY_3_phase_cap(obj.Cshunt, obj.Vfrom_node, delta_t);
            
            [Yc2row, Yc2col, Yc2val] = stampY_3_phase_cap(obj.Cshunt, obj.Vto_node, delta_t);

            %Stamp Series Resistance
            [Yrrow, Yrcol, Yrval] = stamp_3phase_resistance(obj.Rseries, obj.Vfrom_node, obj.Vto_node);
            
            %stamp series Inductor
            
            
        end
        
        function [Jrow, Jval] = stamp_J(obj, delta_t, Vprev)
            
            Jrow = [];
            Jval = [];
            
            %%%STAMP Shunt conductor:
            [Jc1row, Jc1val] = stampJ_3_phase_cap(obj.Cshunt, obj.Vfrom_node, Vprev, delta_t);
            
            
            [Jc2row, Jc2val] = stampJ_3_phase_cap(obj.Cshunt, obj.Vto_node, Vprev, delta_t);

            
        end
        
    end
end

