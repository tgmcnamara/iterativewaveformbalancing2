classdef Bus
    properties
        id {mustBePositive, mustBeInteger}
        bus_data
        BusNum {mustBePositive, mustBeInteger}
        VnInd
        type
        Vm_init
        Vth_init
        Vmax
        Vmin
        T
        dt
        time_series
        interp_method
        Iwaveform_ts
        NodeInds_order
    end
    
    properties (Access = private)
    end
    
    methods
        function obj = Bus(id, bus_data, params)
            obj.id = id;
            obj.bus_data = bus_data;
            obj.BusNum = bus_data(1);
            obj.type = bus_data(2);
            obj.Vm_init = bus_data(8);
            obj.Vth_init = bus_data(9)*pi/180;
            obj.Vmax = bus_data(12);
            obj.Vmin = bus_data(13);
            obj.time_series = 0:params.dt:(params.T-params.dt);
            obj.interp_method = params.interp_method;
        end
        
        function [obj, Vnode_idx] = assign_sta_Vnode_nodes(obj, Vnode_idx)
            obj.VnInd = (Vnode_idx+1):(Vnode_idx+3);
            Vnode_idx = Vnode_idx+3;
        end
        
        function obj = reset_time_series(obj, T, dt)
            obj.T = T;
            obj.dt = dt;
            obj.time_series = 0:dt:T;
        end
        
    end
    
    methods (Access = private)
    end

end