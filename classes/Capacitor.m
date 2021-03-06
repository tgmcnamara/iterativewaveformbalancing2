classdef Capacitor
    %Capacitor - THREE PHASe
    
    properties
        FromNode
        ToNode
        C
        FromNodeInd
        ToNodeInd
        AuxNodeInd
        IcInd
        eq_model
    end
    
    methods
        function obj = Capacitor(C, FromNode, ToNode, eq_model)
            %RESISTOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.C = C;
            obj.FromNode = FromNode;
            obj.ToNode = ToNode;
            obj.eq_model = eq_model; % 1 - thevenin, 2 - norton
        end
        
        function [obj, index_counter] = assign_nodes(FromNodeInds, ToNodeInds, index_counter)
            obj.FromNodeInd = FromNodeInds;
            obj.ToNodeInd = ToNodeInds;
            obj.AuxNodeInd = index_counter:index_counter+2;
            index_counter = index_counter + 3;
            obj.IcInd = index_counter:index_counter+2;
            index_counter = index_counter + 3;
        end
        
        function [y_row, y_col, y_val] = stampY(obj, dt)
            y_row = [];
            y_col = [];
            y_val = [];
            idx = 0;
            
            Geq = dt./(2*obj.C);
            if obj.eq_model == 1 
                % Vfrom rows: Ic leaving
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.IcInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;

                % Aux rows: IC entering
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.IcInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;

                % Aux rows: GcEq*(Vaux-Vto)
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = Geq;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = -Geq;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vto-VAux)
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = Geq;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -Geq;
                idx = idx + 3;

                % IcInd rows: Vc_hist = Vfrom - VCfr
                y_row(idx:idx+2) = obj.IcInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;

                y_row(idx:idx+2) = obj.IcInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1;
            elseif obj.eq_model == 2
                % current OUT of from node
                y_row(idx:idx+2) = obj.FromNodeInd;
                y_col(idx:idx+2) = obj.IcInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                % current IN to aux node
                y_row(idx:idx+2) = obj.AuxNode;
                y_col(idx:idx+2) = obj.IcInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % IcInd rows: 0 = Vfrom - Vaux
                y_row(idx:idx+2) = obj.IcInd;
                y_col(idx:idx+2) = obj.FromNodeInd;
                y_val(idx:idx+2) = 1;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.IcInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -1;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vaux-Vto)
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = Geq;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.AuxNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = -Geq;
                idx = idx + 3;
                
                % Aux rows: GcEq*(Vto-VAux)
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.ToNodeInd;
                y_val(idx:idx+2) = Geq;
                idx = idx + 3;
                
                y_row(idx:idx+2) = obj.ToNodeInd;
                y_col(idx:idx+2) = obj.AuxNodeInd;
                y_val(idx:idx+2) = -Geq;
            else
                error("Invalid equivalent model for capacitor");
            end

        end
        
        function [j_row, j_val] = stampJ(obj, V_prev, dt)
            j_row = [];
            j_val = [];
            idx = 0;
            Vc_prev = V_prev(obj.FromNodeInd) - V_prev(obj.ToNodeInd);
            Ic_prev = V_prev(obk.IcInd);
            if obj.eq_model == 1 % thevenin
                % constant voltage between Vfrom and Vaux
                
                j_row(idx:idx+2) = obj.IcInd;
                j_val(idx:idx+2) = Vc_prev + dt./(2*obj.C).*Ic_prev;
                idx = idx + 3;
            elseif obj.eq_model == 2 % norton
                I_comp = Ic_prev + (2*obj.C)./dt.*Vc_prev;
                % constant current INTO aux node
                j_row(idx:idx+2) = obj.AuxNodeInd;
                j_val(idx:idx+2) = I_comp;
                idx = idx + 3;
                % constant current OUT of from node
                j_row(idx:idx+2) = obj.FromNodeInd;
                j_val(idx:idx+2) = -I_comp;
                idx = idx + 3;
            else
                error("Invalid equivalent model value");
            end
        end
    end
end

