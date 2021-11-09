function [Vn, Vb, Ib] = waveform_init_2_bus(t, buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx)
    out = sim('twobus_transient_sim_explicit', [min(t) max(t)]);
    Ib = zeros(Ibranch_idx, length(t));
    Vb = zeros(Vbranch_idx, length(t));
    Vn = zeros(Vnode_idx, length(t));
    gen_obj = nonlinear_devices(1);
    load_obj = nonlinear_devices(2);
    bus1_obj = buses(1);
    bus2_obj = buses(2);
    br_obj = linear_devices(1);
    
    % bus 1 node voltages
    Vb1_interp = interp1(out.yout{1}.Values.Time, out.yout{1}.Values.Data, t)';
    Vn(bus1_obj.VnInd,:) = Vb1_interp;
    
    % bus 2 node voltages
    Vb2_interp = interp1(out.yout{2}.Values.Time, out.yout{2}.Values.Data, t)';
    Vn(bus2_obj.VnInd,:) = Vb2_interp;
    
    % Tx line ground cap from node voltage
    Vn_cg_fr_interp = interp1(out.yout{20}.Values.Time, out.yout{20}.Values.Data, t);
    Vn(br_obj.Vn_cg_fr,:) = Vn_cg_fr_interp;
    
    Vn_cg_to_interp = interp1(out.yout{21}.Values.Time, out.yout{21}.Values.Data, t);
    Vn(br_obj.Vn_cg_to,:) = Vn_cg_to_interp;
    
    % Tx line branch voltages
    Vb(br_obj.Vb_series,:) = Vb1_interp - Vb2_interp;
    Vb(br_obj.Vb_cshunt_fr,:) = Vb1_interp - Vn_cg_fr_interp;
    Vb(br_obj.Vb_cshunt_to,:) = Vb2_interp - Vn_cg_to_interp;
    Vb(br_obj.Vb_cg_fr, :) = Vn_cg_fr_interp;
    Vb(br_obj.Vb_cg_to, :) = Vn_cg_to_interp;
    % Tx line branch currents
    for i = 0:2
        Ib_series_interp = interp1(out.yout{9+i}.Values.Time, out.yout{9+i}.Values.Data, t)';
        Ib(br_obj.Ib_series(i+1),:) = Ib_series_interp;
        Ib_cshunt_fr_interp = interp1(out.yout{12+i}.Values.Time, out.yout{12+i}.Values.Data, t)';
        Ib(br_obj.Ib_cshunt_fr(i+1),:) = Ib_cshunt_fr_interp;
        Ib_cshunt_to_interp = interp1(out.yout{15+i}.Values.Time, out.yout{15+i}.Values.Data, t)';
        Ib(br_obj.Ib_cshunt_to(i+1),:) = Ib_cshunt_to_interp;
        % Generator branch currents
        ib_gen_interp = interp1(out.yout{3+i}.Values.Time, out.yout{3+i}.Values.Data, t)';
        Ib(gen_obj.IbInds(i+1),:) = ib_gen_interp;
        % Load branch currents
        ib_load_interp = interp1(out.yout{6+i}.Values.Time, out.yout{6+i}.Values.Data, t)';
        Ib(load_obj.IbInds(i+1),:) = ib_load_interp;
%         subplot(3,1,i+1)
%         hold on
%         plot(t, Ib(gen_obj.IbInds(i+1),:));
%         plot(t, Ib(load_obj.IbInds(i+1),:));
    end
    Ib_cg_fr_interp = interp1(out.yout{18}.Values.Time, out.yout{18}.Values.Data, t)';
    Ib(br_obj.Ib_cg_fr,:) = Ib_cg_fr_interp;
    Ib_cg_to_interp = interp1(out.yout{19}.Values.Time, out.yout{19}.Values.Data, t)';
    Ib(br_obj.Ib_cg_fr,:) = Ib_cg_to_interp;
    % Generator branch voltages
    Vb(gen_obj.VbInds,:) = Vb1_interp;
    % Load branch voltages
    Vb(load_obj.VbInds,:) = Vb2_interp;
    
end