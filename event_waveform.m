clc
clear
close all
event_window = .5;
min_time_step = 5e-5;
delta_t = min_time_step;
t = 0:min_time_step:event_window;
f0_init = 60;% used to back calculate L and C from matpower values
baseMVA = 100; %?? 

%parse all the case data with models
%maybe use power flow models to define Y bus
mpc = loadcase('twobus_transient.m');
% mpc = loadcase('twobus_transient_no_caps.m');
%mpc = load('mpc_two_bus.mat').mpc;
node_idx = 0;

[buses, linear_devices, nonlinear_devices, params] = parse_devices(mpc, baseMVA, event_window, delta_t, f0_init);

[buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx] = assign_nodes(buses, linear_devices, nonlinear_devices);

[a_row, a_col, a_val, a_idx] = stamp_incidence_matrix(linear_devices, nonlinear_devices);

[bcr_row, bcr_col, bcr_val, bcr_idx] = stamp_BCR_matrix(linear_devices, nonlinear_devices, delta_t);

%create network admittance matrix with constant time step
%Ylin = makeNetworkMatrix(data,global_time_step);

%find LU factor for linear network cthat will be re-used
%[L,U,P] = lu(Ylin);


%V = zeros(nNodes);
% [Vn, Vb, Ib] = waveform_init_2_bus_no_caps(t, buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx);
[Vn_init, Vb_init, Ib_init] = waveform_init_2_bus(t, buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx);
V_init = [Ib_init; Vb_init; Vn_init];

Vprev = V_init;
max_err = 10;
tol = 1e-4;

nl_row = zeros();
nl_col = zeros();
nl_val = zeros();


Y_sparse = create_Ylinear(a_row, a_col, a_val, a_idx, bcr_row, bcr_col, bcr_val, bcr_idx,Ibranch_idx, Vbranch_idx, Vnode_idx );

iteration = 0;
figure(1)
while max_err> tol
    iteration = iteration+1;
    Vn_prev = Vprev((Ibranch_idx+Vbranch_idx+1):end,:);
    nonlinear_devices = run_nonlinear_device_simulations(nonlinear_devices, Vn_prev, t); 
    Vwvform = calc_Vwvform(Y_sparse,Vprev, t, delta_t ,buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx);
    Ib_sol = Vwvform(1:Ibranch_idx,:);
    Vb_sol = Vwvform((Ibranch_idx+1):(Ibranch_idx+Vbranch_idx),:);
    Vn_sol = Vwvform((Ibranch_idx+Vbranch_idx+1):end,:);
    
        %[Iload_wvform, Igen_wvform, Isc_wvform] = calc_Iwvform_14_bus(V_wform, mpc, event_window);
        
%         if iteration == 1
%             (nl_row, nl_col, nl_val) = chord_approximation(Inl_wform, V_wform, nl_row, nl_col, nl_val);
%         end
%         
       % calc_Vwvform_14_bus(mpc, Iload_wvform, Igen_wvform, Isc_wvform, event_window, min_time_step);

%     if iteration ==1
%        Y = makeY(Ylin, nl_row, nl_col, nl_val); 
%        [L,U,P] = lu(Y);
%     end
%     
%     for t_k=0:global_time_step:event_window
%        
%         V_wform(t_k, :) = U\(L\(P*b));
%         
%     end
    V_error = abs(Vwvform-Vprev);
    max_err = calcMaxErr(Vwvform, Vprev);
    Vprev = Vwvform;
end



