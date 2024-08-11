function [Psi_next, U_next, V_next, Omega_dot_next] = tgv_updateVariables(Omega_now, Psi_now, U_now, V_now, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, WH, WV, A_L, A_U, B, options)
    % Aktualisiere Psi, U, V und Omega_dot basierend auf Omega
    Psi_next = tgv_solvePoisson(Omega_now, A_L, A_U, Psi_now, B);
    [U_next, V_next] = tgv_solveCauchy(Psi_next, D1x, D1y, U_now, V_now, WH, WV, options);
    Omega_dot_next = tgv_solveVorticity(U_next, V_next, Psi_next, Omega_now, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, B, options);
end