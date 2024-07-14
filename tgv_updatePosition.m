function [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options)
    % Diese Funktion aktualisiert die Partikelpositionen basierend auf den
    % linear interpolierten Geschwindigkeitsfeldern U und V.

    % Vektorisierung der Matrizen
    x_pos = X_pos(:); y_pos = Y_pos(:);

    % Berechnung der Partikelpositionen (expliziter Euler-Schritt)
    x_pos = x_pos + options.dt * interp2(X, Y, U, x_pos, y_pos, 'linear', 0);  % Partikelposition in x-Richtung aktualisieren
    y_pos = y_pos + options.dt * interp2(X, Y, V, x_pos, y_pos, 'linear', 0);  % Partikelposition in y-Richtung aktualisieren

    % Rücktransformation in Matrixform
    X_pos = reshape(x_pos, size(X_pos));
    Y_pos = reshape(y_pos, size(Y_pos));
end