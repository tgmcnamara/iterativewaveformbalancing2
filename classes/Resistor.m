classdef Resistor
    %RESISTOR- THREE PHASE
    
    properties
        FromNode
        ToNode
        R
        FromNodeInd
        ToNodeInd
    end
    
    methods
        function obj = Resistor(R, FromNode, ToNode)
            %RESISTOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.R = R;
            obj.FromNode = FromNode;
            obj.ToNode = ToNode;
        end
        
        function obj = assign_nodes(FromNodes, ToNodes)
            obj.FromNodeInd = FromNodes;
            obj.ToNodeInd = ToNodes;
        end
        
        function [y_row, y_col, y_val] = stamp(obj)
            y_row = zeros(1,12);
            y_col = zeros(1,12);
            y_val = zeros(1,12);
            idx = 1;
            
            y_row(idx:idx+2) = obj.FromNodeInd;
            y_col(idx:idx+2) = obj.FromNodeInd;
            y_val(idx:idx+2) = 1./obj.R;
            idx = idx + 3;
            
            y_row(idx:idx+2) = obj.FromNodeInd;
            y_col(idx:idx+2) = obj.ToNodeInd;
            y_val(idx:idx+2) = -1./obj.R;
            idx = idx + 3;

            y_row(idx:idx+2) = obj.ToNodeInd;
            y_col(idx:idx+2) = obj.ToNodeInd;
            y_val(idx:idx+2) = 1./obj.R;
            idx = idx + 3;
            
            y_row(idx:idx+2) = obj.ToNodeInd;
            y_col(idx:idx+2) = obj.FromNodeInd;
            y_val(idx:idx+2) = -1./obj.R;
        end
    end
end

