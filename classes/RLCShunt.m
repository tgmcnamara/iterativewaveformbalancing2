classdef RLCShunt < LinearDevice
    properties
        BusNum {mustBePositive, mustBeInteger}
        id
        R
        L
        C
        NodeVoltageInds
        RnodeInds
        Lnode1Inds
        Lnode2Inds
        ILInds
        CnodeInds
        ICInds
    end
    
    methods
        function obj = Shunt(freq_domain, data)
            obj = obj@LinearDevice(freq_domain);
            obj.BusNum = data.from_bus_num;
            obj.R = data.R;
            obj.L = data.L;
            obj.C = data.C;
        end

        function [obj, node_index] = assign_nodes(obj, bus_map, node_index)
            bus_obj = bus_map(obj.FromBusNum);
            obj.NodeVoltageInds = bus_obj.NodeVoltageInds;
            if ~obj.freq_domain
                if obj.R ~= 0
                    obj.RnodeInds = node_index:(node_index+2);
                    node_index = node_index+3;
                end
                if obj.L ~= 0
                    obj.Lnode1Inds = node_index:(node_index+2);
                    node_index = node_index+3;
                    obj.Lnode2Inds = node_index:(node_index+2);
                    node_index = node_index+3;
                    obj.ILInds = node_index:(node_index+2);
                    node_index = node_index+3;
                end
                if obj.C ~= 0
                    obj.CnodeInds = node_index:(node_index+2);
                    node_index = node_index+3;
                    obj.ICInds = node_index:(node_index+2);
                    node_index = node_index+3;
                end
            end
        end
        
    end
    
end