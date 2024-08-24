function [Omega_next, Omega_dot_next, Psi_next, U_next, V_next, X_next, Y_next] = tgv_solve_heun_step(Omega_now, Omega_dot_now, U_now, V_now, X_now, Y_now, data, options)
    % Berechnung der Strömungsgrößen zum nächsten Zeitpunkt durch das Heun-Verfahren.
    % Entpacken der Konstanten
    D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; X = data.X; Y = data.Y; 
    A_L = data.A_L; A_U = data.A_U; B = data.B; WH = data.WH; WV = data.WV; Psi_bc = data.Psi_bc;
    dt = options.dt;

    % Schritt 1: Vorhersage mit explizitem Euler-Schritt
    Psi_k1 = tgv_solveStream(Omega_now, A_L, A_U, Psi_bc, B);
    [U_k1, V_k1] = tgv_solveVelocity(Psi_k1, D1x, D1y, U_now, V_now, WH, WV, options);
    Omega_dot_k1 = tgv_solveVorticity(U_k1, V_k1, Psi_bc, Omega_now, D1x, D1y, D2x, D2y, B, options);

    % Schritt 3: Berechnung der finalen Werte mit Heun-Verfahren
    Omega_dot_next = (Omega_dot_now + Omega_dot_k1) / 2;
    Omega_next = Omega_now + dt * Omega_dot_next;
    Psi_next = Psi_k1;
    U_next = (U_now + U_k1) / 2;
    V_next = (V_now + V_k1) / 2;
    X_next = X_now + dt * interp2(X, Y, U_next, X_now, Y_now, 'linear', 0);
    Y_next = Y_now + dt * interp2(X, Y, V_next, X_now, Y_now, 'linear', 0);
end
