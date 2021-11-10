classdef NonLinearDevice < matlab.mixin.Heterogeneous
    properties
        Bus {mustBePositive, mustBeInteger}
        VnInd
        Vnom
        fnom
        NeutralNodeIndex
        SimulinkModel % 
        VbInds
        IbInds
        sim_model_file
        sim_instance
        Iwave
        bcr_row_inds
        bcr_vb_offset
    end
    
    properties (Access = private)
    end
    
    methods
        function obj = NonLinearDevice(Bus, Vnom, fnom, sim_model_file)
            obj = obj@matlab.mixin.Heterogeneous();
            obj.Bus = Bus;
            obj.Vnom = Vnom;
            obj.fnom = fnom;
            obj.sim_model_file = sim_model_file;
        end
        
        function [obj, vb_idx_idx] = assign_sta_Vbranch_nodes(obj, vb_idx_idx)
            obj.VbInds = (vb_idx_idx+1):(vb_idx_idx+3);
            vb_idx_idx = vb_idx_idx + 3;
        end
        
        function [obj] = assign_sta_Vnode_nodes(obj, bus_obj)
            obj.VnInd = bus_obj.VnInd;
        end
        
        function [obj, ib_idx_idx] = assign_sta_Ibranch_nodes(obj, ib_idx_idx)
            obj.IbInds = (ib_idx_idx+1):(ib_idx_idx+3);
            ib_idx_idx = ib_idx_idx + 3;
        end
        
        function [obj, bcr_row_idx] = assign_bcr_row_inds(obj, bcr_row_idx, bcr_vb_offset)
            obj.bcr_row_inds = (bcr_row_idx+1):(bcr_row_idx+3);
            bcr_row_idx = bcr_row_idx + 3;
            obj.bcr_vb_offset = bcr_vb_offset;
        end
        
        function [a_row, a_col, a_val, ab_idx] = stampIncidenceMatrix(obj)
            a_row = [];
            a_col = [];
            a_val = [];
            ab_idx = 1;
            
            a_row(ab_idx:(ab_idx+2)) = obj.VnInd;
            a_col(ab_idx:(ab_idx+2)) = obj.IbInds;
            a_val(ab_idx:(ab_idx+2)) = 1;
        end
        
        function [y_row, y_col, y_val] = stamp_BCR_Y(obj)
            y_row = [];
            y_col = [];
            y_val = [];
            idx = 1;
            % alpha*vb + beta*ib = gamma (stamped in Vb rows)
            % for these devices, we just define constant current sources
            % whose values get stamped as gamma in the J
            y_row(idx:(idx+2)) = obj.bcr_row_inds;
            y_col(idx:(idx+2)) = obj.IbInds;
            y_val(idx:(idx+2)) = 1;
        end
        
        function [gamma_row, gamma_val] = stamp_BCR_J(obj, t_ind)
            % gamma values (TIME DEPENDENT!)
            gamma_row = obj.bcr_row_inds;
            %gamma_val = -obj.Iwave(:,t_ind)';
            gamma_val = obj.Iwave(:,t_ind)';
        end
        
        function in = update_inputs(obj, V_wave, t)
            Va = V_wave(1,:);
            Vb = V_wave(2,:);
            Vc = V_wave(3,:);
            in = obj.sim_instance.setExternalInput([t', Va', Vb', Vc']);
            in = in.setModelParameter('StartTime', num2str(min(t)), 'StopTime', num2str(max(t)));

            % out = sim(obj.sim_instance);
            % Iwave = out.yout{1}.Values.Data';
        end
        
        function obj = save_Iwave(obj, sim_out, interp, t_sys)
            Isim = sim_out.yout{1}.Values.Data;
            tsim = sim_out.yout{1}.Values.Time;
            if interp
                obj.Iwave = interp1(tsim, Isim, t_sys')';
            else
                obj.Iwave = Isim';
            end
        end
        
    end
    
end