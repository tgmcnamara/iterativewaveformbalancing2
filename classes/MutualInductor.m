classdef MutualInductor
    %MutualInductor Summary of this class goes here
    %   Detailed explanation goes here
    
    %Inductor - THREE PHASE - series inductance only
    
    properties
        FromNode
        ToNode
        M
        FromNodeInd
        ToNodeInd
        CoupledIl1Ind
        CoupledIl2Ind
        ImInd
        eq_model
    end
    
    methods
        function obj = MutualInductor(L, FromNode, ToNode, eq_model)
            %RESISTOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.M = M;
            obj.FromNode = FromNode;
            obj.ToNode = ToNode;
            obj.eq_model = eq_model; % 1 - thevenin, 2 - norton
        end
        
        function [obj, index_counter] = assign_nodes(FromNodeInds, ToNodeInds, CoupledIlInds, index_counter)
            obj.FromNodeInd = FromNodeInds;
            obj.ToNodeInd = ToNodeInds;
            obj.CoupledIl1Ind = [CoupledIlInds(2); CoupledIlInds(3); CoupledIlInds(1)];
            obj.CoupledIl2Ind = [CoupledIlInds(3); CoupledIlInds(1); CoupledIlInds(2)];
            obj.ImInd = index_counter:index_counter+2;
            index_counter = index_counter + 3;
        end
        
        function [y_row, y_col, y_val] = stampY(obj, dt)
            y_row = [];
            y_col = [];
            y_val = [];
            idx = 0;
            
            if obj.eq_model == 1
                % Im OUT of from node
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.ImInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                % Im INTO to to node
                y_row(idx:idx+2) = obj.ToNode;
                y_col(idx:idx+2) = obj.ImInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % (V_from - V_to) - 2M/dt*Il1 - 2M/dt*Il2 = -Vm_hist
                % Vm hist stamped in J function
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.CoupledIl1Ind;
                y_val(idx:idx+2) = -2*obj.M./dt;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.CoupledIl2Ind;
                y_val(idx:idx+2) = -2*obj.M./dt;
                idx = idx + 3;
            elseif obj.eq_model == 2 % Norton
                % Im OUT of from node
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.ImInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                % Im INTO to to node
                y_row(idx:idx+2) = obj.ToNode;
                y_col(idx:idx+2) = obj.ImInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % dt/2*(V_from - V_to) - M*Il1 - M*Il2 = -Vm_hist
                % Vm hist stamped in J function
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = dt/2;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = dt/2;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.CoupledIl1Ind;
                y_val(idx:idx+2) = obj.M./dt;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ImInd;
                y_col(idx:idx+2) = obj.CoupledIl2Ind;
                y_val(idx:idx+2) = obj.M./dt;
                idx = idx + 3;
            else
                error("Invalid equivalent model for capacitor");
            end

        end
        
        function [j_row, j_val] = stampJ(obj, V_prev, dt)
            j_row = [];
            j_val = [];
            idx = 0;
            Vm_prev = V_prev(obj.FromNodeInd) - V_prev(obj.ToNodeInd);
            CoupledIl1_prev = V_prev(obj.CoupledIl1Ind);
            CoupledIl2_prev = V_prev(obj.CoupledIl2Ind);
            if obj.eq_model == 1 % thevenin
                j_row(idx:idx+2) = obj.IlInd;
                j_val(idx:idx+2) = -Vm_prev - 2*obj.M/dt*CoupledIl1_prev - 2*obj.M.dt*CoupledIl2_prev;
                idx = idx + 3;
            elseif obj.eq_model == 2 % norton
                j_row(idx:idx+2) = obj.IlInd;
                j_val(idx:idx+2) = -dt/2*Vm_prev - obj.M*CoupledIl1_prev - obj.M*CoupledIl2_prev;
                idx = idx + 3;
            else
                error("Invalid equivalent model value");
            end
        end
    end
end

