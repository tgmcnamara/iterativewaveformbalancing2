classdef Inductor
    %Inductor - THREE PHASE - series inductance only
    
    properties
        FromNode
        ToNode
        L
        FromNodeInd
        ToNodeInd
        AuxNodeInd
        IlInd
        eq_model
    end
    
    methods
        function obj = Inductor(L, FromNode, ToNode, eq_model)
            %RESISTOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.L = L;
            obj.FromNode = FromNode;
            obj.ToNode = ToNode;
            obj.eq_model = eq_model; % 1 - thevenin, 2 - norton
        end
        
        function [obj, index_counter] = assign_nodes(FromNodeInds, ToNodeInds, index_counter)
            obj.FromNodeInd = FromNodeInds;
            obj.ToNodeInd = ToNodeInds;
            obj.AuxNodeInd = index_counter:index_counter+2;
            index_counter = index_counter + 3;
            obj.IlInd = index_counter:index_counter+2;
            index_counter = index_counter + 3;
        end
        
        function [y_row, y_col, y_val] = stampY(obj, dt)
            y_row = [];
            y_col = [];
            y_val = [];
            idx = 0;
            
            Req = 2*obj.L./dt;
            if obj.eq_model == 1
                % current OUT of from node
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.IlInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                % current IN to aux node
                y_row(idx:idx+2) = obj.AuxNode;
                y_col(idx:idx+2) = obj.IlInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % IlInd rows: Vl_const = Vfrom - Vaux
                y_row(idx:idx+2) = obj.IlInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.IlInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vaux-Vto)
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = 1./Req;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = -1./Req;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vto-VAux)
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = 1./Req;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1./Req;
            elseif obj.eq_model == 2 % Norton
                % Vfrom rows: Il leaving
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.IlInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;

                % Aux rows: Il entering
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.IlInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;

                % Aux rows: Geq*(Vaux-Vto)
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = 1./Req;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = -1./Req;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vto-VAux)
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = 1./Req;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1./Req;
                idx = idx + 3;

                % IlInd rows: 0 = Vfrom - VAux
                y_row(idx:idx+2) = obj.IlInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;

                y_row(idx:idx+2) = obj.IlInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1;
            else
                error("Invalid equivalent model for capacitor");
            end

        end
        
        function [j_row, j_val] = stampJ(obj, V_prev, dt)
            j_row = [];
            j_val = [];
            idx = 0;
            Vl_prev = V_prev(obj.FromNodeInd) - V_prev(obj.ToNodeInd);
            Il_prev = V_prev(obj.IlInd);
            Req = (2*obj.L)./dt;
            if obj.eq_model == 1 % thevenin
                % constant voltage between Vfrom and Vaux
                j_row(idx:idx+2) = obj.IlInd;
                j_val(idx:idx+2) = Vl_prev + Req.*Il_prev;
                idx = idx + 3;
            elseif obj.eq_model == 2 % norton
                I_comp = Il_prev + Vl_prev./Req;
                % constant current OUT of aux node
                j_row(idx:idx+2) = obj.AuxNodeInd;
                j_val(idx:idx+2) = -I_comp;
                idx = idx + 3;
                % constant current INTO to node
                j_row(idx:idx+2) = obj.ToNodeInd;
                j_val(idx:idx+2) = I_comp;
                idx = idx + 3;
            else
                error("Invalid equivalent model value");
            end
        end
    end
end

