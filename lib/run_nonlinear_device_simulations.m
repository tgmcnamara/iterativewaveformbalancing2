function [nonlinear_devices] = run_nonlinear_device_simulations(nonlinear_devices, Vn, t)

    for nl_ind = 1:length(nonlinear_devices)
        nl_obj = nonlinear_devices(nl_ind);
        V_wave = Vn(nl_obj.VnInd,:);
        simIn(nl_ind) = nl_obj.update_inputs(V_wave, t);
    end
%     simOut = parsim(simIn);
    for i=1:length(simIn)
        simOut(i) = sim(simIn(i));
    end
    
    for nl_ind = 1:length(nonlinear_devices)
        sim_out_obj = simOut(nl_ind);
        nl_obj = nonlinear_devices(nl_ind);
        nl_obj = nl_obj.save_Iwave(sim_out_obj, true, t);
        nonlinear_devices(nl_ind) = nl_obj;     
    end

end

