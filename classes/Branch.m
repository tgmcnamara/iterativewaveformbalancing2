classdef Branch
    %BRANCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FromBusNum {mustBePositive, mustBeInteger}
        ToBusNum {mustBePositive, mustBeInteger}

        L_series
        R_series
        R_mutual
        L_mutual
        Cshunt
        Cground
        Vn_bus_fr % copy of bus obj nodes ERR 2e-4
        Vn_bus_to % copy of bus obj nodes ERR 12
        Vb_series % 3 inds ERR 4e-4
        Ib_series % 3 inds ERR ~1.2
        Vb_cshunt_fr % 3 inds ERR 2e4
        Ib_cshunt_fr % 3 inds ERR ~1
        Vb_cshunt_to % 3 inds ERR ~12
        Ib_cshunt_to % 3 inds ERR ~1.2
        Vn_cg_fr %single phase ERR 6e-9
        Vb_cg_fr %single phase ERR 1e-9
        Ib_cg_fr %single phase ERR 1e-10
        Vn_cg_to %single phase
        Vb_cg_to %single phase ERR 2e-9
        Ib_cg_to %single phase ERR 8e-10
        series_bcr_rows
        cshfr_bcr_rows
        cgndfr_bcr_row
        cshto_bcr_rows
        cgndto_bcr_row
        bcr_vb_offset
    end
    
    methods
        function obj = Branch(branch_data, params)
            obj.FromBusNum = branch_data(1);
            obj.ToBusNum = branch_data(2);
            r1 = branch_data(3);
            r0 = branch_data(4);
            l1 = branch_data(5);
            l0 = branch_data(6);
            c1 = branch_data(7);
            c0 = branch_data(8);
            obj.R_series = (2*r1 + r0)/3;
            obj.R_mutual = (r0 - r1)/3;
            obj.L_series = (2*l1 + l0)/3;
            obj.L_mutual = (l0 - l1)/3;
            if c1 ~= 0 && c0 ~= 0
                obj.Cshunt = c1;
                obj.Cground = 3*c1*c0/(c1-c0);
            else
                obj.Cshunt = 0;
                obj.Cground = 0;
            end
        end
        
        % ASSIGNING STA NODES IN ORDER OF IBRANCH, VBRANCH, VNODE
        
        function [obj, node_index] = assign_sta_Ibranch_nodes(obj, node_index)
           
            obj.Ib_series = node_index+1:(node_index+3);
            node_index = node_index+3;
            if obj.Cshunt ~=0
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
            if obj.Cshunt~=0
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
        
        function [obj, node_index] = assign_sta_Vnode_nodes(obj, node_index, from_bus_obj, to_bus_obj)
            obj.Vn_bus_fr = from_bus_obj.VnInd;
            obj.Vn_bus_to = to_bus_obj.VnInd;
            if obj.Cshunt~=0
                obj.Vn_cg_fr = node_index+1;
                node_index = node_index+1;
                obj.Vn_cg_to = node_index+1;
                node_index = node_index+1;
            end
        end
        
        function [obj, bcr_row_idx] = assign_bcr_row_inds(obj, bcr_row_idx, bcr_vb_offset)
            obj.series_bcr_rows = (bcr_row_idx+1):(bcr_row_idx+3);
            bcr_row_idx = bcr_row_idx + 3;
            if obj.Cshunt ~= 0
                obj.cshfr_bcr_rows = (bcr_row_idx+1):(bcr_row_idx+3);
                bcr_row_idx = bcr_row_idx + 3;
                obj.cshto_bcr_rows = (bcr_row_idx+1):(bcr_row_idx+3);
                bcr_row_idx = bcr_row_idx + 3;
                obj.cgndfr_bcr_row = bcr_row_idx+1;
                bcr_row_idx = bcr_row_idx + 1;
                obj.cgndto_bcr_row = bcr_row_idx+1;
                bcr_row_idx = bcr_row_idx + 1;
            end
            obj.bcr_vb_offset = bcr_vb_offset;
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
           
           a_row = [a_row, obj.Vn_bus_to];
           a_col = [a_col, obj.Ib_series];
           a_val = [a_val, -1,-1,-1];
           idx_a = idx_a+3;
           if obj.Cshunt ~= 0
               a_row = [a_row, obj.Vn_bus_fr];
               a_col = [a_col, obj.Ib_cshunt_fr];
               a_val = [a_val, 1,1,1];
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
           
        end
        
        
        function [ylin_row, ylin_col, ylin_val] = stamp_BCRlinear_matrix(obj, delta_t)
            [ys_row, ys_col, ys_val] = stamp_sta_series_BCR(obj,delta_t);
            if obj.Cshunt ~= 0
                [ysh_row, ysh_col, ysh_val] = stamp_sta_shunt_BCR(obj, delta_t);
            else
                ysh_row = [];
                ysh_col = [];
                ysh_val = [];
            end
            
            ylin_row = [ys_row, ysh_row];
            ylin_col = [ys_col, ysh_col];
            ylin_val = [ys_val, ysh_val];
        end
        
        function [ylin_row, ylin_col, ylin_val] = stamp_sta_series_BCR(obj, delta_t)
            
            ylin_row = [];
            ylin_col = [];
            ylin_val = [];

            %stamping Vseries = Iseries*R_series + L_series*blah
            ylin_row = [ylin_row, obj.series_bcr_rows];
            ylin_col = [ylin_col, obj.Vb_series+obj.bcr_vb_offset];
            ylin_val = [ylin_val, -1,-1,-1];
            
            %stamping resistance part
            ylin_row = [ylin_row, obj.series_bcr_rows];
            ylin_col = [ylin_col, obj.Ib_series];
            ylin_val = [ylin_val, obj.R_series, obj.R_series, obj.R_series];
            
            % %stamping inductance part
            % ylin_row = [ylin_row, obj.series_bcr_rows];
            % ylin_col = [ylin_col, obj.Vb_series];
            % ylin_val = [ylin_val, 0.5*delta_t./obj.L_series];

            %stamping inductance part
            ylin_row = [ylin_row, obj.series_bcr_rows];
            ylin_col = [ylin_col, obj.Ib_series];
            ylin_val = [ylin_val, 2*obj.L_series./delta_t, 2*obj.L_series./delta_t, 2*obj.L_series./delta_t];
        end
        
        function [jlin_row, jlin_val, jlin_idx] = stamp_BCR_J(obj, delta_t, Ibranch_prev, Vbranch_prev)
            
            [js_row, js_val, js_idx] = stamp_sta_series_J(obj, delta_t, Ibranch_prev, Vbranch_prev);
            if obj.Cshunt ~= 0
                [jsh_row, jsh_val, jsh_idx] = stamp_sta_shunt_J(obj, delta_t, Ibranch_prev, Vbranch_prev);
%             jsh_row = jsh_row + js_idx;
            else
                jsh_row = [];
                jsh_col = [];
                jsh_val = [];
            end
            jlin_row = [js_row, jsh_row];
            jlin_val = [js_val, jsh_val];
%             jlin_idx = js_idx+;
            jlin_idx = 0;
            
        end
        
        function [ jlin_row, jlin_val, idx_j] = stamp_sta_series_J(obj, delta_t, Ibranch_prev, Vbranch_prev)

            jlin_row = [];
            jlin_val = [];
            idx_j = 0;
            Vb_prev = Vbranch_prev(obj.Vb_series);
            Ib_prev = Ibranch_prev(obj.Ib_series);
            
            J_stamp = (Vb_prev + Ib_prev*(-obj.R_series + 2*obj.L_series./delta_t))';
            
            jlin_row = [jlin_row,  obj.series_bcr_rows];
            jlin_val = [jlin_val, J_stamp];
            
%             %stamping inductance part
%                 Il_prev = Ibranch_prev(obj.Ib_series);
%                 Vl_prev = Vbranch_prev(obj.Vb_series) - Il_prev.*obj.R_series;
%         
%                 jlin_row = [jlin_row, obj.series_bcr_rows];
%                 J_stamp = -(Il_prev  + (0.5*delta_t./obj.L_series).*(Vl_prev))';
%                 jlin_val = [jlin_val, J_stamp];
%             
%             idx_j = idx_j +3;
        end
        
        
        
        function [ylin_row, ylin_col, ylin_val] = stamp_sta_shunt_BCR(obj, delta_t)
            ylin_row = [];
            ylin_col = [];
            ylin_val = [];
              
            %stamp from shunt capacitors
            ylin_row = [ylin_row, obj.cshfr_bcr_rows];
            ylin_col = [ylin_col, obj.Vb_cshunt_fr+obj.bcr_vb_offset];
            ylin_val = [ylin_val, -1, -1, -1];
            
            ylin_row = [ylin_row, obj.cshfr_bcr_rows];
            ylin_col = [ylin_col, obj.Ib_cshunt_fr];
            ylin_val = [ylin_val, (delta_t./obj.Cshunt), (delta_t./obj.Cshunt), (delta_t./obj.Cshunt)];

                        
            %to capacitor shunts
            ylin_row = [ylin_row, obj.cshto_bcr_rows];
            ylin_col = [ylin_col, obj.Vb_cshunt_to+obj.bcr_vb_offset];
            ylin_val = [ylin_val, -1, -1, -1];
            
            ylin_row = [ylin_row, obj.cshto_bcr_rows];
            ylin_col = [ylin_col, obj.Ib_cshunt_to];
            ylin_val = [ylin_val, (delta_t./obj.Cshunt), (delta_t./obj.Cshunt), (delta_t./obj.Cshunt)];            
            
            %stamp from ground capacitor
            ylin_row = [ylin_row, obj.cgndfr_bcr_row];
            ylin_col = [ylin_col, obj.Ib_cg_fr];
            ylin_val = [ylin_val, 0.5*(delta_t./obj.Cground)];
            
            ylin_row = [ylin_row, obj.cgndfr_bcr_row];
            ylin_col = [ylin_col, obj.Vb_cg_fr+obj.bcr_vb_offset];
            ylin_val = [ylin_val, -1];
            
            %stamp to ground capacitor
            ylin_row = [ylin_row, obj.cgndto_bcr_row];
            ylin_col = [ylin_col, obj.Ib_cg_to];
            ylin_val = [ylin_val, (delta_t./obj.Cground)];
            
            ylin_row = [ylin_row, obj.cgndto_bcr_row];
            ylin_col = [ylin_col, obj.Vb_cg_to+obj.bcr_vb_offset];
            ylin_val = [ylin_val, -1];
        end
    
        function [jlin_row, jlin_val, jlin_row_idx] = stamp_sta_shunt_J(obj, delta_t, Ibranch_prev, Vbranch_prev)
            jlin_row = [];
            jlin_val = [];
            jlin_row_idx = 0;
            
            Vcap_fr_prev = Vbranch_prev(obj.Vb_cshunt_fr);
            Icap_fr_prev = Ibranch_prev(obj.Ib_cshunt_fr);
 
            Vcap_to_prev = Vbranch_prev(obj.Vb_cshunt_to);
            Icap_to_prev = Ibranch_prev(obj.Ib_cshunt_to);
            
            Vcg_fr_prev = Vbranch_prev(obj.Vb_cg_fr);
            Icg_fr_prev = Ibranch_prev(obj.Ib_cg_fr);
            
            Vcg_to_prev = Vbranch_prev(obj.Vb_cg_to);
            Icg_to_prev = Ibranch_prev(obj.Ib_cg_to);
            
            %stamp from capacitors
            jlin_row = [jlin_row, obj.cshfr_bcr_rows];
            jlin_val = [jlin_val, -(Vcap_fr_prev + (delta_t./obj.Cshunt).*Icap_fr_prev)'];
            
            jlin_row_idx = jlin_row_idx+3;
            
            %stamp to capacitors
            jlin_row = [jlin_row, obj.cshto_bcr_rows];
            jlin_val = [jlin_val, -(Vcap_to_prev + (delta_t./obj.Cshunt).*Icap_to_prev)'];
            
            jlin_row_idx = jlin_row_idx+3;

            %stamp from ground capacitor
            jlin_row = [jlin_row, obj.cgndfr_bcr_row];
            jlin_val = [jlin_val, -(Vcg_fr_prev + (delta_t/obj.Cground)*Icg_fr_prev)'];
            
            jlin_row_idx = jlin_row_idx + 1;
            
            %stamp to ground capacitor
            jlin_row = [jlin_row, obj.cgndto_bcr_row];
            jlin_val = [jlin_val, -(Vcg_to_prev + (delta_t/obj.Cground)*Icg_to_prev)'];
            
            jlin_row_idx = jlin_row_idx + 1;
        end
    end
end

