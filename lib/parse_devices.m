function [buses, linear_devices, nonlinear_devices, params] = parse_devices(mpc, baseMVA, T, dt, f0_init)
    
    params = Params(mpc, baseMVA, T, dt, f0_init, 'linear');
    
    % modify case files to add mutual inductance info...
    % and mutual capacitance and resistance?
    buskeys = zeros(params.n_bus, 1);
    busids = zeros(params.n_bus, 1);
    buses = [];
    branches = [];
    generators = [];
    sync_conds = [];
    loads = [];
    shunts = [];
    shunt_data = [];
    for bus_ind = 1:params.n_bus
        bus_data = mpc.bus(bus_ind,:);
        bus_obj = Bus(bus_ind, bus_data, params);
        busids(bus_ind) = bus_ind;
        buskeys(bus_ind) = bus_data(1);
        buses = [buses bus_obj];
        Gsh = bus_data(5);
        Bsh = bus_data(6);
        if Gsh ~= 0 || Bsh ~= 0
            shunt_data = [shunt_data; bus_data(1) Gsh Bsh];
        end
    end
    
    bus_id_map = containers.Map(buskeys, busids);
    
    for br_ind = 1:params.n_branch
        br_data = mpc.branch(br_ind,:);
        br_obj = Branch(br_data, params);
        branches = [branches br_obj];
    end
    
    linear_devices = branches;
    
    params.n_load = size(mpc.load,1);
    params.n_shunt = size(shunt_data,1);
        
    for load_ind = 1:params.n_load
        load_data = mpc.load(load_ind,:);
        bus_id = bus_id_map(load_data(1));
        bus_obj = buses(bus_id);
        Vnom = bus_obj.Vm_init;
        load_obj = Load(load_data, Vnom, params, 'load_sim2');
        load_obj = load_obj.init_sim();
        loads = [loads load_obj];
    end
    
    for gen_ind = 1:size(mpc.gen,1)
        gen_data = mpc.gen(gen_ind,:);
        bus_id = bus_id_map(gen_data(1));
        bus_obj = buses(bus_id);
        gen_obj = Generator(gen_data, params, bus_obj, 'generator_sim2');
        gen_obj = gen_obj.init_sim();
        generators = [generators gen_obj];
    end
    
    for sc_ind = 1:size(mpc.sync_cond,1)
        sc_data = mpc.sync_cond(sc_ind,:);
        bus_id = bus_id_map(sc_data(1));
        bus_obj = buses(bus_id);
        sync_cond_obj = SynchronousCondenser(sc_data, params, bus_obj, 'sync_condenser_sim');
        sync_cond_obj = sync_cond_obj.init_sim();
        sync_conds = [sync_conds sync_cond_obj];
    end
    
    nonlinear_devices = [generators sync_conds loads];
end