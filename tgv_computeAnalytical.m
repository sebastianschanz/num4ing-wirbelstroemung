function [U_a, V_a, Psi_a] = tgv_computeAnalytical(X_pos_a, Y_pos_a, t, nu)
    % Diese Funktion berechnet die analytische Lösung des Taylor-Green-Vortex.
    Psi_a = sin(X_pos_a).*sin(Y_pos_a).*exp(-2*nu*t); % Analytische Stromfunktion
    U_a = sin(X_pos_a).*cos(Y_pos_a).*exp(-2*nu*t); % Analytische Geschwindigkeitskomponente U
    V_a = -cos(X_pos_a).*sin(Y_pos_a).*exp(-2*nu*t); % Analytische Geschwindigkeitskomponente V
end