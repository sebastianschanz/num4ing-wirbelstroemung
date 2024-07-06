function [U_a, V_a, Psi_a] = tgv_computeAnalytical(X_pos_a, Y_pos_a, t, nu)
    Psi_a = sin(X_pos_a).*sin(Y_pos_a).*exp(-2*nu*t);
    U_a = sin(X_pos_a).*cos(Y_pos_a).*exp(-2*nu*t);
    V_a = -cos(X_pos_a).*sin(Y_pos_a).*exp(-2*nu*t);
end