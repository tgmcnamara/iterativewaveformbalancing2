classdef SynchronousCondenser < Generator
    %SYNCHRONOUSCONDENSER Summary of this class goes here
    %   Detailed explanation goes here
    methods
        function obj = SynchronousCondenser(sc_data, params, bus_obj, sim_model_file)
            %SYNCHRONOUSCONDENSER Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Generator(sc_data, params, bus_obj, sim_model_file);
            % enforce that P = 0?
            obj.P = 0;
            % enforce that it is a PQ bus? or PV with P=0?
            obj.type = 'PQ';
        end
        
        function obj = init_sim(obj)
            % TODO:
            % - scale P, Q, V with from per unit to 
            %   full values before putting into block
            % - need to mess with transformer somehow?
            load_system(obj.sim_model_file);
            obj.sim_instance = Simulink.SimulationInput(obj.sim_model_file);
            
            gen_str = strcat(obj.sim_model_file, '/Synchronous condensor_1');
            obj.sim_instance.setBlockParameter(gen_str, 'BusType', obj.type);
            obj.sim_instance.setBlockParameter(gen_str, 'InternalConnection', obj.configuration);            
            obj.sim_instance.setBlockParameter(gen_str, 'Pref', num2str(obj.P));
            obj.sim_instance.setBlockParameter(gen_str, 'Qref', num2str(obj.Qinit));
            obj.sim_instance.setBlockParameter(gen_str, 'Qmax', num2str(obj.Qmax));
            obj.sim_instance.setBlockParameter(gen_str, 'Qmin', num2str(obj.Qmin));
            obj.sim_instance.setBlockParameter(gen_str, 'Resistance', num2str(obj.R_source));
            obj.sim_instance.setBlockParameter(gen_str, 'Inductance', num2str(obj.L_source));
        end
        
    end
end

