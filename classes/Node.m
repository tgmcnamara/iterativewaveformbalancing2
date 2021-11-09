classdef Node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Ind
        n
    end
    
    methods
        function [obj, node_map] = Node(name, n, node_map)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Name = name;
            obj.n = n;
            node_map(Name) = obj;
        end
        
        function [index_counter, obj] = assign_nodes(obj,index_counter)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.Ind = index_counter:(index_counter+obj.n-1);
            index_counter = index_counter + obj.n;
        end
    end
end

