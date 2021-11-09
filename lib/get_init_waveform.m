function [V_init,t] = get_init_waveform(mpc, f0, T, dt)
    
    % run case
    results = runpf(mpc);
    t = 0:dt:(T-dt);
    omega = 2*pi*f0;
    
    n_bus = size(mpc.bus, 1);
    V_init = zeros(3*n_bus, length(t));
    % slack_bus = find(mpc.bus(:,2) == 3);
    
    for bus_ind = 1:size(mpc.buses,1)
        Vm = results.bus(bus_ind, 8);
        Vth = results.bus(bus_ind, 9)*pi/180.0;
        for phase = 1:3
            th = Vth - 2*pi*(phase-1)/3;
            V_init(3*(bus_ind-1)+phase,:) = Vm*real(exp(1i*(omega*t + th)));
        end
    end
end