function [V] = calc_Vwvform(Y_sparse,Vprev, t, delta_t, buses, linear_devices, nonlinear_devices, Ibranch_idx, Vbranch_idx, Vnode_idx)

    
    V = zeros(size(Vprev));
    V(:,1) = Vprev(:,1);
    for t_ind = 2:length(t)
        t_k = t(t_ind);
        %V_prev_t = V(:,t_ind-1);
        Ibranch_prev = V(1:Ibranch_idx, t_ind-1);
        Vbranch_prev = V(Ibranch_idx+1:(Vbranch_idx+Ibranch_idx), t_ind-1);
        [j_row, j_val, j_idx] = stamp_BCR_J(t_ind, delta_t, buses, linear_devices, nonlinear_devices, Ibranch_prev, Vbranch_prev);
        j_col = ones(size(j_row));
        % need to make sure BCR rows in J match up with the BCR stamps
        % being at the bottom of Y
        j_row = j_row + (Ibranch_idx+Vnode_idx);
        J_t = sparse(j_row, j_col, j_val);
        V_t = Y_sparse\J_t;   
        Ib_t = V_t(1:Ibranch_idx);
        Vb_t = V_t(Ibranch_idx+1:Ibranch_idx+Vbranch_idx);
        Vn_t = V_t(Ibranch_idx+Vbranch_idx+1:end);
        V(:,t_ind) = V_t;
    end


end

