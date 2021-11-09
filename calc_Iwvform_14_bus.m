function [Iload_wvform, Igen_wvform, Isc_wvform] = calc_Iwvform_14_bus(Vwvform, mpc, time_stop)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    nload = size(mpc.load,1);
    ngen = size(mpc.gen,1);
    nsync_cond = size(mpc.sync_cond,1);
    
    stopTime = sprintf('%.6f',time_stop);
    
    load_type = {'constant Z', 'constant PQ', 'constant I'};
    load_config = {'Y (grounded)', 'Y (floating)', 'Y (neutral)', 'Delta'};
    rlc_load_timestep = '5e-5';
    
    gen_type = {'swing', 'PV', 'PQ'};
    gen_config = {'Y', 'Yn', 'Yg'};
    gen_timestep = '5e-5';
    
    sync_cond_type = {'swing', 'PV', 'PQ'};
    sync_cond_config = {'Y', 'Yn', 'Yg'};
    sync_timestep = '5e-5';
    
    Iwvform = timeseries.empty(14,0);
    
    
    Iload_wvform = timeseries.empty(14,0);
    Igen_wvform = timeseries.empty(14,0);
    Isc_wvform = timeseries.empty(14,0);
    
    for nl_idx = 1:nload
       
        bus_num = mpc.load(nl_idx,1);
        
        set_param('rlc_load_wvform','StopTime',stopTime);
        set_param('rlc_load_wvform/powergui','SampleTime',rlc_load_timestep);
        
        set_param('rlc_load_wvform/Three-Phase Series RLC Load1','LoadType',load_type{mpc.load(nl_idx,2)});
        
        set_param('rlc_load_wvform/Three-Phase Series RLC Load1','ActivePower', sprintf('%.6f',mpc.load(nl_idx, 4)));
        set_param('rlc_load_wvform/Three-Phase Series RLC Load1','InductivePower', sprintf('%.6f',mpc.load(nl_idx, 5)));
        set_param('rlc_load_wvform/Three-Phase Series RLC Load1','CapacitivePower', sprintf('%.6f',mpc.load(nl_idx, 6)));

        Vload_bus = Vwvform(bus_num);
        Vl_a_ts = timeseries(Vload_bus.Data(:,1), Vload_bus.Time);
        Vl_b_ts = timeseries(Vload_bus.Data(:,2), Vload_bus.Time);
        Vl_c_ts = timeseries(Vload_bus.Data(:,3), Vload_bus.Time);
        options = simset('SrcWorkspace','current');
        simout = sim('rlc_load_wvform',[],options);
        
        Iload = simout.load_I;
    
        Iload_wvform(bus_num) = Iload;

    end


    
    for nl_gen= 1:ngen
        
        bus_num = mpc.gen(nl_gen,1);
        
        gen_type_i = gen_type{mpc.gen(nl_gen,2)};
        gen_config_i = gen_config{mpc.gen(nl_gen,3)};
        Pg = sprintf('%.6f',mpc.gen(nl_gen,4));
        Qg = sprintf('%.6f',mpc.gen(nl_gen,5));
        maxQ = sprintf('%.6f',mpc.gen(nl_gen,6));
        minQ = sprintf('%.6f',mpc.gen(nl_gen,7));
        sourceR = sprintf('%.6f',mpc.gen(nl_gen,8));
        sourceL = sprintf('%.6f',mpc.gen(nl_gen,9));
        baseV = sprintf('%.6f',mpc.gen(nl_gen,10));
        
        set_param('gen_wvform','StopTime',stopTime);
        set_param('gen_wvform/powergui','SampleTime',rlc_load_timestep);     
        set_param('gen_wvform/Generator 1','BusType',gen_type_i);
        set_param('gen_wvform/Generator 1','Pref',Pg);
        set_param('gen_wvform/Generator 1','Qref',Qg);
        set_param('gen_wvform/Generator 1','Qmin',minQ);
        set_param('gen_wvform/Generator 1','Qmax',maxQ);
        set_param('gen_wvform/Generator 1','Resistance',sourceR);
        set_param('gen_wvform/Generator 1','Inductance',sourceL);
        set_param('gen_wvform/Generator 1','BaseVoltage',baseV);

        
        Vgen_bus = Vwvform(bus_num);
        Vg_a_ts = timeseries(Vgen_bus.Data(:,1), Vgen_bus.Time);
        Vg_b_ts = timeseries(Vgen_bus.Data(:,2), Vgen_bus.Time);
        Vg_c_ts = timeseries(Vgen_bus.Data(:,3), Vgen_bus.Time);
        
        options = simset('SrcWorkspace','current');

        simout = sim('gen_wvform',[],options);
        
        Igen = simout.gen_I;
        
        Igen_wvform(bus_num) = Igen;

        
    end

    
    for nl_sc = 1:nsync_cond
        
        
        bus_num = mpc.sync_cond(nl_sc,1);
        
        gen_type_i = sync_cond_type{mpc.sync_cond(nl_sc,2)};
        gen_config_i = sync_cond_config{mpc.sync_cond(nl_sc,3)};
        Pg = sprintf('%.6f',mpc.sync_cond(nl_sc,4));
        Qg = sprintf('%.6f',mpc.sync_cond(nl_sc,5));
        maxQ = sprintf('%.6f',mpc.sync_cond(nl_sc,6));
        minQ = sprintf('%.6f',mpc.sync_cond(nl_sc,7));
        sourceR = sprintf('%.6f',mpc.sync_cond(nl_sc,8));
        sourceL = sprintf('%.6f',mpc.sync_cond(nl_sc,9));
        baseV = sprintf('%.6f',mpc.sync_cond(nl_sc,10));
        
        set_param('sync_condenser_wvform','StopTime',stopTime);
        set_param('sync_condenser_wvform/powergui','SampleTime',rlc_load_timestep);
        set_param('sync_condenser_wvform/Synchronous condensor_1','BusType',gen_type_i);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Pref',Pg);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Qref',Qg);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Qmin',minQ);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Qmax',maxQ);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Resistance',sourceR);
        set_param('sync_condenser_wvform/Synchronous condensor_1','Inductance',sourceL);
        set_param('sync_condenser_wvform/Synchronous condensor_1','BaseVoltage',baseV);

        
        Vgen_bus = Vwvform(bus_num);
        Vsc_a_ts = timeseries( Vgen_bus.Data(:,1), Vgen_bus.Time);
        Vsc_b_ts = timeseries( Vgen_bus.Data(:,2), Vgen_bus.Time);
        Vsc_c_ts = timeseries( Vgen_bus.Data(:,3), Vgen_bus.Time);
        
        options = simset('SrcWorkspace','current');
        simout = sim('sync_condenser_wvform',[], options);
        
        Igen = simout.sc_I;
        
        Isc_wvform(bus_num) = Igen;
        
        
    end
    
    
end

