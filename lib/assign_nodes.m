function [buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx, bcr_row_idx] = assign_nodes(buses, linear_devices, nonlinear_devices)
    
    n_lin = size(linear_devices,2);
    n_nlin = size(nonlinear_devices,2);
    n_bus = size(buses,2);
    
    % 
    Ibranch_idx = 0;
    Vbranch_idx = 0;
    Vnode_idx = 0;
    bcr_row_idx = 0;
    
    %assign the Ibranch nodes first
    for n_l = 1:n_lin
        lin_device = linear_devices(n_l);
        [lin_device, Ibranch_idx] = lin_device.assign_sta_Ibranch_nodes(Ibranch_idx);
        linear_devices(n_l) = lin_device;
    end

    for n_nl = 1:n_nlin
        nlin_device = nonlinear_devices(n_nl);
        [nlin_device, Ibranch_idx] = nlin_device.assign_sta_Ibranch_nodes(Ibranch_idx);
        nonlinear_devices(n_nl) = nlin_device;
        
    end

    %assign the Vbranch indices 
    for n_l = 1:n_lin
        
        lin_device = linear_devices(n_l);
        [lin_device, Vbranch_idx] = lin_device.assign_sta_Vbranch_nodes(Vbranch_idx);
        linear_devices(n_l) = lin_device;
    end
    for n_nl = 1:n_nlin
        nlin_device = nonlinear_devices(n_nl);
        [nlin_device, Vbranch_idx] = nlin_device.assign_sta_Vbranch_nodes(Vbranch_idx);
        nonlinear_devices(n_nl) = nlin_device;
    end
    
    %assign the Vnode indices
    bus_keys = zeros(1,n_bus);
    for n_b = 1:n_bus
        bus = buses(n_b);
        [bus, Vnode_idx] = bus.assign_sta_Vnode_nodes(Vnode_idx);
        buses(n_b) = bus;
        bus_keys(n_b) = bus.BusNum;
    end
    bus_id_map = containers.Map(bus_keys, (1:n_bus));
    
    for n_l = 1:n_lin
        lin_device = linear_devices(n_l);
        from_bus_obj = buses(bus_id_map(lin_device.FromBusNum));
        to_bus_obj = buses(bus_id_map(lin_device.ToBusNum));        
        [lin_device, Vnode_idx] = lin_device.assign_sta_Vnode_nodes(Vnode_idx, from_bus_obj, to_bus_obj);
        linear_devices(n_l) = lin_device;
    end
    
    for n_nl = 1:n_nlin
        nlin_device = nonlinear_devices(n_nl);
        bus_obj = buses(bus_id_map(nlin_device.Bus));
        nlin_device = nlin_device.assign_sta_Vnode_nodes(bus_obj);
        nonlinear_devices(n_nl) = nlin_device;
    end
    
    % assign the BCR equation row indices
    for n_l = 1:n_lin
        lin_device = linear_devices(n_l);
        [lin_device, bcr_row_idx] = lin_device.assign_bcr_row_inds(bcr_row_idx, Ibranch_idx);
        linear_devices(n_l) = lin_device;
    end
    
    for n_nl = 1:n_nlin
        nlin_device = nonlinear_devices(n_nl);
        [nlin_device, bcr_row_idx] = nlin_device.assign_bcr_row_inds(bcr_row_idx, Ibranch_idx);
        nonlinear_devices(n_nl) = nlin_device;
    end
    
end

