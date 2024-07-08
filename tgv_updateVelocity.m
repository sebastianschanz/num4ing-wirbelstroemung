function [U, V] = tgv_updateVelocity(Psi, D1x, D1y, options)
    % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion Psi
    U = D1y * Psi(:);  % Geschwindigkeit U aus der Stromfunktion
    V = -D1x * Psi(:);  % Geschwindigkeit V aus der Stromfunktion

    % Rücktransformation in Matrixform
    U = reshape(U, [options.x_nr, options.y_nr]);
    V = reshape(V, [options.x_nr, options.y_nr]);
end
