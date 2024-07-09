function [U, V] = tgv_updateVelocity(Psi, D1x, D1y, options)
    % Diese Funktion berechnet die Geschwindigkeitskomponenten U und V
    % aus der Stromfunktion Psi.

    % Berechnung der Geschwindigkeiten U und V aus der Stromfunktion Psi
    U = D1y * Psi(:);
    V = -D1x * Psi(:);

    % Rücktransformation in Matrixform
    U = reshape(U, [options.x_nr, options.y_nr]);
    V = reshape(V, [options.x_nr, options.y_nr]);
end
