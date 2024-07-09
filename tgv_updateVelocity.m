function [U, V] = tgv_updateVelocity(Psi, D1x, D1y, options)
    % Diese Funktion berechnet die Geschwindigkeitskomponenten U und V
    % aus der Stromfunktion Psi.

    % Berechnung der Geschwindigkeiten U und V aus der Stromfunktion Psi
    u = D1y * Psi(:);
    v = -D1x * Psi(:);

    % Rücktransformation in Matrixform
    U = reshape(u, [options.x_nr, options.y_nr]);
    V = reshape(v, [options.x_nr, options.y_nr]);
end
