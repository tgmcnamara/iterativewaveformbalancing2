classdef Load < NonLinearDevice
    %Load Summary of this class goes here
    %   Detailed explanation goes here
    properties
        type
        configuration
        P
        Qind
        Qcap
    end
    
    methods
        function obj = Load(load_data, Vnom, params, sim_model_file)
            fnom = params.fnom;
            obj = obj@NonLinearDevice(load_data(1), Vnom, fnom, sim_model_file);
            obj.type = load_data(2);
            if load_data(3) == 1
                obj.configuration = 'Y (grounded)';
            elseif load_data(3) == 2
                obj.configuration = 'Y (floating)';
            elseif load_data(3) == 3
                obj.configuration = 'Y (neutral)';                
            elseif load_data(3) == 4
                obj.configuration = 'Delta';       
            else
                error("Invalid load configuration");
            end
            obj.P = load_data(4);
            obj.Qind = load_data(5);
            obj.Qcap = load_data(6);
            obj.sim_model_file = sim_model_file;            
        end
        
        function obj = assign_nodes(obj, bus_map, buses)
            bus_ind = bus_map(obj.Bus);
            obj.VoltageInds = buses(bus_ind).NodeInds;
        end
        
        function obj = init_sim(obj)
            load_system(obj.sim_model_file);
            obj.sim_instance = Simulink.SimulationInput(obj.sim_model_file);
            load_block_str = strcat(obj.sim_model_file, '/Load1');
            obj.sim_instance = obj.sim_instance.setBlockParameter(load_block_str, 'Configuration', obj.configuration);            
            obj.sim_instance = obj.sim_instance.setBlockParameter(load_block_str, 'ActivePower', num2str(obj.P));            
            obj.sim_instance = obj.sim_instance.setBlockParameter(load_block_str, 'InductivePower', num2str(obj.Qind));
            obj.sim_instance = obj.sim_instance.setBlockParameter(load_block_str, 'CapacitivePower', num2str(obj.Qcap));
            % TODO - set nominal voltage and frequency
        end

    end
end

