classdef Generator < NonLinearDevice
    %Generator Summary of this class goes here
    %   Detailed explanation goes here
    properties
        type
        configuration
        P
        Qinit
        Qmax
        Qmin
        R_source
        L_source
        Vm_set
        interp_method
    end
    
    methods
        function obj = Generator(gen_data, params, bus_obj, sim_model_file)
            fnom = params.fnom;
            obj = obj@NonLinearDevice(gen_data(1),  bus_obj.Vm_init, fnom, sim_model_file);
            % if bus_obj.type ~= gen_data(2)
            %     error('Generator type does not match type of associated bus');
            % end
            obj.Vm_set = gen_data(10);
            if gen_data(2) == 1
                obj.type = 'PV';
            elseif gen_data(2) == 2
                obj.type = 'PQ';
            elseif gen_data(2) == 3
                obj.type = 'swing';
            else
                error("Invalid bus type in gen_data");
            end
            if gen_data(3) == 1
                obj.configuration = 'Y';
            elseif gen_data(3) == 2
                obj.configuration = 'Yn';
            elseif gen_data(3) == 3
                obj.configuration = 'Yg';
            else
                error("Invalid configuration value in gen_data");
            end
            obj.P = gen_data(4);
            obj.Qinit = gen_data(5);
            obj.Qmax = gen_data(6);
            obj.Qmin = gen_data(7);
            obj.R_source = gen_data(8);
            obj.L_source = gen_data(9);
            obj.interp_method = params.interp_method;
            obj.sim_model_file = sim_model_file;
        end
        
        function obj = assign_nodes(obj, bus_map, buses)
            bus_ind = bus_map(obj.Bus);
            obj.VoltageInds = buses(bus_ind).NodeInds;
        end
        
        function obj = init_sim(obj)
            % TODO:
            % - scale P, Q, V with from per unit to 
            %   full values before putting into block
            % - need to mess with transformer somehow?
            load_system(obj.sim_model_file);
            obj.sim_instance = Simulink.SimulationInput(obj.sim_model_file);
            gen_str = strcat(obj.sim_model_file, '/Generator 1');
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'BusType', obj.type);
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Voltage', num2str(obj.Vm_set));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'InternalConnection', obj.configuration);            
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Pref', num2str(obj.P));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Qref', num2str(obj.Qinit));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Qmax', num2str(obj.Qmax));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Qmin', num2str(obj.Qmin));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Resistance', num2str(obj.R_source));
            obj.sim_instance = obj.sim_instance.setBlockParameter(gen_str, 'Inductance', num2str(obj.L_source));
        end
        
    end
end

