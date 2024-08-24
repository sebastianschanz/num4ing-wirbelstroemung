function [Omega_next, Omega_dot_next, Psi_next, U_next, V_next, X_next, Y_next] = tgv_solve_rk4_step(Omega_now, ~, U_now, V_now, X_now, Y_now, data, options)
    % Berechnung der Strömungsgrößen zum nächsten Zeitpunkt durch das Runge-Kutta-Verfahren 4. Ordnung
    % Entpacken der Konstanten
    D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; X = data.X; Y = data.Y; 
    A_L = data.A_L; A_U = data.A_U; B = data.B; WH = data.WH; WV = data.WV; Psi_bc = data.Psi_bc;
    dt = options.dt;

    % Schritt 1: Berechnung von k1
    Psi_k1 = tgv_solveStream(Omega_now, A_L, A_U, Psi_bc, B);
    [U_k1, V_k1] = tgv_solveVelocity(Psi_k1, D1x, D1y, U_now, V_now, WH, WV, options);
    Omega_dot_k1 = tgv_solveVorticity(U_k1, V_k1, Psi_bc, Omega_now, D1x, D1y, D2x, D2y, B, options);

    % Schritt 2: Berechnung von k2
    Psi_k2 = tgv_solveStream(Omega_now + 0.5 * dt * Omega_dot_k1, A_L, A_U, Psi_bc, B);
    [U_k2, V_k2] = tgv_solveVelocity(Psi_k2, D1x, D1y, U_now + 0.5 * dt * U_k1, V_now + 0.5 * dt * V_k1, WH, WV, options);
    Omega_dot_k2 = tgv_solveVorticity(U_k2, V_k2, Psi_bc, Omega_now + 0.5 * dt * Omega_dot_k1, D1x, D1y, D2x, D2y, B, options);

    % Schritt 3: Berechnung von k3
    Psi_k3 = tgv_solveStream(Omega_now + 0.5 * dt * Omega_dot_k2, A_L, A_U, Psi_bc, B);
    [U_k3, V_k3] = tgv_solveVelocity(Psi_k3, D1x, D1y, U_now + 0.5 * dt * U_k2, V_now + 0.5 * dt * V_k2, WH, WV, options);
    Omega_dot_k3 = tgv_solveVorticity(U_k3, V_k3, Psi_bc, Omega_now + 0.5 * dt * Omega_dot_k2, D1x, D1y, D2x, D2y, B, options);

    % Schritt 4: Berechnung von k4
    Psi_k4 = tgv_solveStream(Omega_now + dt * Omega_dot_k3, A_L, A_U, Psi_bc, B);
    [U_k4, V_k4] = tgv_solveVelocity(Psi_k4, D1x, D1y, U_now + dt * U_k3, V_now + dt * V_k3, WH, WV, options);
    Omega_dot_k4 = tgv_solveVorticity(U_k4, V_k4, Psi_bc, Omega_now + dt * Omega_dot_k3, D1x, D1y, D2x, D2y, B, options);

    % Schritt 5: Berechnung der finalen Werte durch gewichtetes Mittel
    Omega_dot_next = (Omega_dot_k1 + 2 * Omega_dot_k2 + 2 * Omega_dot_k3 + Omega_dot_k4) / 6;
    Omega_next = Omega_now + dt * Omega_dot_next;
    Psi_next = (Psi_k1 + 2 * Psi_k2 + 2 * Psi_k3 + Psi_k4) / 6;
    U_next = (U_k1 + 2 * U_k2 + 2 * U_k3 + U_k4) / 6;
    V_next = (V_k1 + 2 * V_k2 + 2 * V_k3 + V_k4) / 6;
    X_next = X_now + dt * interp2(X, Y, U_next, X_now, Y_now, 'linear', 0);
    Y_next = Y_now + dt * interp2(X, Y, V_next, X_now, Y_now, 'linear', 0);
end
