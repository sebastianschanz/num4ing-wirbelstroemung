function [Omega_next, Omega_dot_next, Psi_next, U_next, V_next, X_next, Y_next] = tgv_solve_exEuler_step(Omega_now, ~, U_now, V_now, X_now, Y_now, data, options)
    % Heun-Verfahren zur Berechnung der Strömungsgrößen und Partikelpositionen zum nächsten Zeitpunkt.
    % Entpacken der Konstanten
    D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; X = data.X; Y = data.Y; 
    A_L = data.A_L; A_U = data.A_U; B = data.B; WH = data.WH; WV = data.WV; Psi_bc = data.Psi_bc;
    dt = options.dt;

    % Berechnung der Strömungsgrößen und Partikelpositionen
    Psi_next = tgv_solveStream(Omega_now, A_L, A_U, Psi_bc, B);
    [U_next, V_next] = tgv_solveVelocity(Psi_next, D1x, D1y, U_now, V_now, WH, WV, options);
    X_next = X_now + dt * interp2(X, Y, U_now, X_now, Y_now, 'linear', 0);
    Y_next = Y_now + dt * interp2(X, Y, V_now, X_now, Y_now, 'linear', 0);
    Omega_dot_next = tgv_solveVorticity(U_next, V_next, Psi_bc, Omega_now, D1x, D1y, D2x, D2y, B, options);
    Omega_next = Omega_now + dt * Omega_dot_next;
end