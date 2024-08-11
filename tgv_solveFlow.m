function [Psi_next, U_next, V_next, Omega_dot_next] = tgv_solveFlow(Omega_now, Psi_bc, U, V, D1x, D1xp, D1xm, D1yp, D1ym, D1y, D2x, D2y, A_L, A_U, B, WH, WV, options)
    % Aktualisiere Psi, U, V und Omega_dot basierend auf Omega
    Psi_next = tgv_solveStream(Omega_now, A_L, A_U, Psi_bc, B);
    [U_next, V_next] = tgv_solveVelocity(Psi_next, D1x, D1y, U, V, WH, WV, options);
    Omega_dot_next = tgv_solveVorticity(U, V, Psi_bc, Omega_now, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, B, options);
end