classdef BranchOld
    properties
        FromBusNum {mustBePositive, mustBeInteger}
        ToBusNum {mustBePositive, mustBeInteger}
        L_series
        R_series
        L_mutual
        C_shunt
        Vn_bus_fr
        Vn_bus_to
        Vb_series
        Ib_series
        Vb_cshunt_fr
        Ib_cshunt_fr
        Vb_cshunt_to
        Ib_cshunt_to
        Vn_cg_fr %single phase
        Vb_cg_fr %single phase
        Ib_cg_fr %single phase
        Vn_cg_to %single phase
        Vb_cg_to %single phase
        Ib_cg_to %single phase
           
        
    end
    
    methods
        function obj = BranchOld(branch_data, params)
            obj.FromBusNum = branch_data(1);
            obj.ToBusNum = branch_data(2);
            omega = 2*pi*params.f0_init;
            obj.R_series = branch_data(3);
            obj.L_series = branch_data(4)/omega;
            obj.C_shunt = branch_data(5)*omega;

            obj.L_mutual = 0*obj.L_series; % ???

            
        end

        function [obj, node_index] = assign_bus_nodes(obj, bus_map, node_index)
            from_bus_obj = bus_map(obj.FromBusNum);
            to_bus_obj = bus_map(obj.ToBusNum);
            obj.Vn_bus_fr = from_bus_obj.NodeInds;
            obj.Vn_bus_to = to_bus_obj.NodeInds;
%             if obj.R_series == 0 || obj.L_series == 0 || obj.L_mutual == 0
%                 error("Zero-value Tx line R and L not implemented");
%             end
%             obj.RNode_indices = node_index:(node_index+2);
%             node_index = node_index + 3;
%             obj.L1Node_indices = node_index:(node_index+2);
%             node_index = node_index + 3;
%             obj.L2Node_indices = node_index:(node_index+2);
%             node_index = node_index + 3;
%             obj.IL_indices = node_index:(node_index+2);
%             node_index = node_index + 3;
%             obj.IL_CCVS_indices = node_index:(node_index+2);
%             node_index = node_index + 3;
%             if obj.C ~= 0
%                 obj.CfrNode_indices = node_index:(node_index+2);
%                 node_index = node_index + 3;
%                 obj.ICfr_indices = node_index:(node_index+2);
%                 node_index = node_index + 3;
%                 obj.CtoNode_indices = node_index:(node_index+2);
%                 node_index = node_index + 3;
%                 obj.ICto_indices = node_index:(node_index+2);
%                 node_index = node_index + 3;
%             end
        end
        
%%%ASSIGNING STA NODES IN ORDER OF IBRANCH, VBRANCH, VNODE
        
        function [obj, node_index] = assign_sta_Ibranch_nodes(obj, node_index)
           
            obj.Ib_series = node_index+1:(node_index+3);
            node_index = node_index+3;
            if obj.C ~=0
                obj.Ib_cshunt_fr = node_index+1:(node_index+3);
                node_index = node_index+3;
                obj.Ib_cshunt_to = node_index+1:(node_index+3);
                node_index = node_index+3;
                obj.Ib_cg_fr = node_index+1;
                node_index = node_index+1;
                obj.Ib_cg_to = node_index+1;
                node_index = node_index+1;
            end
            
        end
        
        function [obj, node_index] = assign_sta_Vbranch_nodes(obj, node_index)
           
            obj.Vb_series = node_index+1:(node_index+3);
            node_index = node_index + 3;
            if obj.C~=0
                obj.Vb_cshunt_fr = node_index+1:(node_index+3);
                node_index = node_index+3;
                obj.Vb_cshunt_to = node_index+1:(node_index+3);
                node_index = node_index+3;
                obj.Vb_cg_fr = node_index+1;
                node_index = node_index+1;
                obj.Vb_cg_to = node_index+1;
                node_index = node_index+1;                
            end
            
        end
        
        
        function [obj, node_index] = assign_sta_Vnode_nodes(obj, node_index)
            
            if obj.C~=0
                
                obj.Vn_cg_fr = node_index+1;
                node_index = node_index+1;
                obj.Vn_cg_to = node_index+1;
                node_index = node_index+1;
            end
        end
        
        
        function [obj] = assign_bus_map_indicies(obj, bus_map)

            from_bus_obj = bus_map(obj.FromBusNum);
            to_bus_obj = bus_map(obj.ToBusNum);
            obj.FromNode_indices = from_bus_obj.NodeInds;
            obj.ToNode_indices = to_bus_obj.NodeInds;
            
            obj.FromNode_Voltage_Indicies = from_bus_obj.node_voltage_index;
            obj.ToNode_Voltage_Indicies = to_bus_obj.node_voltage_index;
            
        end
        
        
        
        function [a_row, a_col, a_val, idx_a] = stampIncidenceMatrix(obj)
            
           a_row = [];
           a_col = [];
           a_val = [];
           idx_a = 0;
           
           a_row = [a_row, obj.Vn_bus_fr];
           a_col = [a_col, obj.Ib_series];
           a_val = [a_val, 1,1,1];
           idx_a = idx_a+3;
           
           a_row = [a_row, obj.Vn_bus_fr];
           a_col = [a_col, obj.Ib_cshunt_fr];
           a_val = [a_val, 1,1,1];
           idx_a = idx_a+3;

           a_row = [a_row, obj.Vn_bus_to];
           a_col = [a_col, obj.Ib_series];
           a_val = [a_val, -1,-1,-1];
           idx_a = idx_a+3;

           a_row = [a_row, obj.Vn_bus_to];
           a_col = [a_col, obj.Ib_cshunt_to];
           a_val = [a_val, 1,1,1];
           idx_a = idx_a+3;
           
           a_row = [a_row, obj.Vn_cg_fr];
           a_col = [a_col, obj.Ib_cg_fr];
           a_val = [a_val, 1];
           idx_a = idx_a+1;

           a_row = [a_row, obj.Vn_cg_fr, obj.Vn_cg_fr, obj.Vn_cg_fr];
           a_col = [a_col, obj.Ib_cshunt_fr];
           a_val = [a_val, -1,-1,-1];
           idx_a = idx_a+3;

           a_row = [a_row, obj.Vn_cg_to];
           a_col = [a_col, obj.Ib_cg_to];
           a_val = [a_val, 1];
           idx_a = idx_a+1;

           a_row = [a_row, obj.Vn_cg_to, obj.Vn_cg_to, obj.Vn_cg_to];
           a_col = [a_col, obj.Ib_cshunt_to];
           a_val = [a_val, -1,-1,-1];
           idx_a = idx_a+3;
           
        end
        
        
        function [ylin_row, ylin_col, ylin_val,  ylin_row_idx] = stamp_sta_series_Y(obj, delta_t)
            
           
            ylin_row = [];
            ylin_col = [];
            ylin_val = [];

            ylin_row_idx = 0;
            
            %stamping Vseries = Iseries*Rseries + Lseries*blah
            ylin_row = [ylin_row, ylin_row_idx+1, ylin_row_idx+2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Vb_series];
            ylin_val = [ylin_val, -1,-1,-1];
            
            %stamping resistance part
            ylin_row = [ylin_row, ylin_row_idx+1, ylin_row_idx+2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Ib_series];
            ylin_val = [ylin_val, obj.Rseries];
            
            %stamping inductance part
            ylin_row = [ylin_row, ylin_row_idx+1, ylin_row_idx+2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Vb_series];
            ylin_val = [ylin_val, 0.5*delta_t./obj.Lseries];
            
            ylin_row_idx = ylin_row_idx+3;        

            
            
        end
        
        
        function [ jlin_row, jlin_val, idx_j] = stamp_sta_series_J(obj, delta_t, Ibranch_prev, Vbranch_prev)

            jlin_row = [];
            jlin_val = [];
            idx_j = 0;
            ylin_row_idx=0;
            %stamping inductance part
            Il_prev = Ibranch_prev(obj.Ib_series);
            Vl_prev = Vbranch_prev(obj.Vb_series) - Il_prev.*obj.Rseries;
        
            jlin_row = [jlin_row, ylin_row_idx+1, ylin_row_idx+2, ylin_row_idx+3];
            jlin_val = [jlin_val, Il_prev  + (0.5*delta_t./obj.Lseries).*(Vl_prev)];
            
            idx_j = idx_j +3;
        end
        
        
        
        function [ylin_row, ylin_col, ylin_val, ylin_row_idx] = stamp_sta_shunt_Y(obj, delta_t)

            
            ylin_row = [];
            ylin_col = [];
            ylin_val = [];
  
            ylin_row_idx = 0;
            
            %stamp from shunt capacitors
            ylin_row = [ylin_row, ylin_row_idx + 1, ylin_row_idx + 2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Vb_cshunt_fr];
            ylin_val = [ylin_val, -1, -1, -1];
            
            ylin_row = [ylin_row, ylin_row_idx + 1, ylin_row_idx + 2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Ib_cshunt_fr];
            ylin_val = [ylin_val, (delta_t./obj.Cshunt)];

            
            ylin_row_idx = ylin_row_idx+3;
            
            %to capacitor shunts
            ylin_row = [ylin_row, ylin_row_idx + 1, ylin_row_idx + 2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Vb_cshunt_to];
            ylin_val = [ylin_val, -1, -1, -1];
            
            ylin_row = [ylin_row, ylin_row_idx + 1, ylin_row_idx + 2, ylin_row_idx+3];
            ylin_col = [ylin_col, obj.Ib_cshunt_to];
            ylin_val = [ylin_val, (delta_t./obj.Cshunt)];

            ylin_row_idx = ylin_row_idx+3;
            
            
            %stamp from ground capacitor
            ylin_row = [ylin_row, ylin_row_idx+1];
            ylin_col = [ylin_col, obj.Vb_cg_from];
            ylin_val = [ylin_val, (delta_t/obj.Cground)];
            
            ylin_row_idx = ylin_row_idx+1;
            %stamp to ground capacitor
            ylin_row = [ylin_row, ylin_row_idx+1];
            ylin_col = [ylin_col, obj.Vb_cg_from];
            ylin_val = [ylin_val, (delta_t/obj.Cground)];
            
        end
    
        function [jlin_row, jlin_val, jlin_row_idx] = stamp_sta_shunt_J(obj, delta_t, Ibranch_prev, Vbranch_prev)

    
            jlin_row = [];
            jlin_val = [];
            jlin_row_idx = 0;
            
            Vcap_fr_prev = Vbranch_prev(obj.Vb_cshunt_fr);
            Icap_fr_prev = Ibranch_prev(obj.Ib_cshunt_fr);
 
            Vcap_to_prev = Vbranch_prev(obj.Vb_cshunt_to);
            Icap_to_prev = Ibranch_prev(obj.Ib_cshunt_to);
            
            %stamp from capacitors
            jlin_row = [jlin_row, jlin_row_idx + 1, jlin_row_idx + 2, jlin_row_idx+3];
            jlin_val = [jlin_val, Vcap_fr_prev + 0.5*(delta_t./obj.Cshunt).*Icap_fr_prev];
            
            jlin_row_idx = jlin_row_idx+3;
            
            %stamp to capacitors
            jlin_row = [jlin_row, jlin_row_idx + 1, jlin_row_idx + 2, jlin_row_idx+3];
            jlin_val = [jlin_val, Vcap_to_prev + 0.5*(delta_t./obj.Cshunt).*Icap_to_prev];
            
            jlin_row_idx = jlin_row_idx+3;

            %stamp from ground capacitor
            
        end
    
    
    
    
    
    
    
    
        
        function [ylin_row, ylin_col, ylin_val, idx_Y] = stampY(obj, ylin_row, ylin_col, ylin_val, idx_Y)
            % mutual capacitances, resistances ignored for now
            
            % stamp R
            % V_from rows: 1/R*(Vfrom - R1_node)
            ylin_row(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_val(idx_Y:idx_Y+2) = 1/obj.R_series;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_val(idx_Y:idx_Y+2) = -1/obj.R_series;
            idx_Y = idx_Y + 3;
            % R1_node rows: 1/R*(R1_node - Vfrom)
            ylin_row(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_val(idx_Y:idx_Y+2) = 1/obj.R_series;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_val(idx_Y:idx_Y+2) = 1/obj.R_series;
            idx_Y = idx_Y + 3;
            
            % R1_node rows: IL exiting
            ylin_row(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.IL_indices;
            ylin_val(idx_Y:idx_Y+2) = 1;
            idx_Y = idx_Y + 3;
            
            % L1_node rows: IL entering
            ylin_row(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.IL_indices;
            ylin_val(idx_Y:idx_Y+2) = -1;
            idx_Y = idx_Y + 3;
            
            % IL rows: VR1 = VL1 --> -VR1 + VL1 = 0
            ylin_row(idx_Y:idx_Y+2) = obj.IL_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.RNode_indices;
            ylin_val(idx_Y:idx_Y+2) = -1;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.IL_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_val(idx_Y:idx_Y+2) = 1;
            idx_Y = idx_Y + 3;
            
            % L1_node rows: GLeq*(VL1 - VL2)
            GLeq = dt/(2*obj.L_series);
            ylin_row(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_val(idx_Y:idx_Y+2) = GLeq;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.L2Node_indices;
            ylin_val(idx_Y:idx_Y+2) = GLeq;
            idx_Y = idx_Y + 3;
            
            % L2_node rows: GLeq(VL2 - VL1)
            ylin_row(idx_Y:idx_Y+2) = obj.L2Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.L1Node_indices;
            ylin_val(idx_Y:idx_Y+2) = -GLeq;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.L2Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.L2Node_indices;
            ylin_val(idx_Y:idx_Y+2) = GLeq;
            idx_Y = idx_Y + 3;
            
            % L2_node rows: I_CCVS exiting
            ylin_row(idx_Y:idx_Y+2) = obj.L2Node_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.IL_CCVS_indices;
            ylin_val(idx_Y:idx_Y+2) = 1;
            idx_Y = idx_Y + 3;
            
            % V_to rows: I_CCVS entering
            ylin_row(idx_Y:idx_Y+2) = obj.ToNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.IL_CCVS_indices;
            ylin_val(idx_Y:idx_Y+2) = -1;
            idx_Y = idx_Y + 3;
            
            % I_CCVS rows: mutual inductance equations
            % phase a: -Vmutual_hist(a) = -VL2(a) + Vto + GMeq*ib + GMeq*ic 
            for i = 1:3            
                ylin_row(idx_Y) = obj.IL_CCVS_indices(i);
                ylin_col(idx_Y) = obj.L2Node_indices(i);
                ylin_val(idx_Y) = -1;
                idx_Y = idx_Y + 1;

                ylin_row(idx_Y) = obj.IL_CCVS_indices(i);
                ylin_col(idx_Y) = obj.ToNode_indices(i);
                ylin_val(idx_Y) = 1;
                idx_Y = idx_Y + 1;
                for other_phase = 1:3
                    if other_phase == i
                        continue
                    end
                    GMeq = obj.L_mutual*dt/2;
                    ylin_row(idx_Y) = obj.IL_CCVS_indices(i);
                    ylin_col(idx_Y) = obj.IL_indices(pther_phase);
                    ylin_val(idx_Y) = GMeq;
                    idx_Y = idx_Y + 1;
                end
            end
            
            if obj.C == 0
                return
            end

            % Vfrom rows: ICfr leaving
            ylin_row(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.ICfr_indices;
            ylin_val(idx_Y:idx_Y+2) = 1;
            idx_Y = idx_Y + 3;
            
            % Cfr rows: ICfr entering
            ylin_row(idx_Y:idx_Y+2) = obj.CfrNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.ICfr_indices;
            ylin_val(idx_Y:idx_Y+2) = -1;
            idx_Y = idx_Y + 3;
            
            % Cfr rows: GCeq*VCfr
            GCeq = dt/obj.C;
            ylin_row(idx_Y:idx_Y+2) = obj.CfrNode_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.ICfr_indices;
            ylin_val(idx_Y:idx_Y+2) = GCeq;
            idx_Y = idx_Y + 3;
            
            % ICfr rows: Vc_hist = Vfrom - VCfr
            ylin_row(idx_Y:idx_Y+2) = obj.ICfr_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.FromNode_indices;
            ylin_val(idx_Y:idx_Y+2) = 1;
            idx_Y = idx_Y + 3;
            
            ylin_row(idx_Y:idx_Y+2) = obj.ICfr_indices;
            ylin_col(idx_Y:idx_Y+2) = obj.CfrNode_indices;
            ylin_val(idx_Y:idx_Y+2) = -1;
            idx_Y = idx_Y + 3;
            
        end
        
        function [j_row, j_val, idx_J] = update_Jhist(obj, V_prev, dt, j_row, j_val, idx_J)
            % equivalent inductor currents
            VL_prev = V_prev(obj.L1Node_indices) - V_prev(obj.L2Node_indices);
            IL_const = V_prev(obj.IL_indices) + dt/2*obj.L_series*VL_prev;
            % OUT of L1 nodes
            j_row(idx_J:idx_J+2) = obj.L1Node_indices;
            j_val(idx_J:idx_Y+2) = -IL_const;
            idx_J = idx_J + 3;
            % INTO L2 nodes
            j_row(idx_J:idx_J+2) = obj.L2Node_indices;
            j_val(idx_J:idx_Y+2) = IL_const;
            idx_J = idx_J + 3;
            
            % CCVS voltages
            GMeq = obj.L_mutual*dt/2;
            for i = 1:3
                CCVS_voltage = V_prev(obj.L2Node_indices(i))-V_prev(obj.ToNode_indices(i));
                for other_phase = 1:3
                    if other_phase == i
                        continue
                    end
                    CCVS_voltage = CCVS_voltage + GMeq*V_prev(obj.IL_indices(pther_phase));
                end
                j_row(idx_J) = obj.IL_CCVS_indices(i);
                j_val(idx_J) = CCVS_voltage;
                idx_J = idx_J + 1;
            end
            
            if obj.C == 0
                return
            end
            
            % capacitor voltages
            j_row(idx_J:idx_J+2) = obj.ICfr_indices;
            j_val(idx_J:idx_Y+2) = V_prev(FromNode_indices) + dt/obj.C*V_prev(ICfr_indices);
            idx_J = idx_J + 3;
            
            j_row(idx_J:idx_J+2) = obj.ICto_indices;
            j_val(idx_J:idx_Y+2) = V_prev(ToNode_indices) + dt/obj.C*V_prev(ICto_indices);
            idx_J = idx_J + 3;
            
        end
    end
    
end