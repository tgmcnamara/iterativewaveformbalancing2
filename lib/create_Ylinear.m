function [Y] = create_Ylinear(a_row, a_col, a_val, a_idx, bcr_row, bcr_col, bcr_val, bcr_idx,Ibranch_idx, Vbranch_idx, Vnode_idx );

    %Y   =  A; 0; 0            V = Ib
    %       0; -I; At              Vb
    %       BCR                    Vn
    n_b = Ibranch_idx;
    n_n = Vnode_idx;
    % A should be n_n x n_b
    % At should be n_b x n_n
    % BCR should be n_b x (2*n_b+n_n)
    A = sparse(a_row, a_col, a_val, n_n, n_b);
    % At = sparse(a_col, a_row, a_val); %TODO check
    At = sparse(a_col, a_row, a_val, n_b, n_n); %TODO check
    BCR = sparse(bcr_row, bcr_col, bcr_val, n_b, (2*n_b+n_n));
    A_size = size(A);
    At_size = size(At);
    BCR_size = size(BCR);
    col_size = BCR_size(2);
%     row_size = A_size(1)+At_size(1)+BCR_size(1);
%     col3_size = col_size - A_size(2) - At_size(2);
    
    %Y = [A, zeros(At_size), zeros(A_size(1),col3_size) ; zeros(At_size(1)), At, -eye(At_size(1), col3_size); BCR];
    Y = [A, zeros(n_n, n_b), zeros(n_n) ; zeros(n_b), -eye(n_b), At; BCR];
    
end

