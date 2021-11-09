classdef Params
    %PARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        case_name
        baseMVA
        n_bus
        n_branch
        n_shunt
        n_gen
        n_load
        T
        dt
        fnom
        bus_map
        gen_map
        interp_method
    end
    
    methods
        function obj = Params(mpc, baseMVA, T, dt, fnom, interp_method)
            %PARAMS Construct an instance of this class
            %   Detailed explanation goes here
            obj.baseMVA = baseMVA;
            obj.T = T;
            obj.dt = dt;
            obj.fnom = fnom;
            obj.n_bus = size(mpc.bus,1);
            obj.n_gen = nnz(mpc.gen(:,8));
            obj.n_branch = size(mpc.branch,1);
            obj.interp_method = interp_method;
        end
        
    end
end

