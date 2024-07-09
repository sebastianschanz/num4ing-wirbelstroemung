function [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options)
    % Diese Funktion aktualisiert die Partikelpositionen basierend auf den
    % linear interpolierten Geschwindigkeitsfeldern U und V.

    % Berechnung der Partikelpositionen (expliziter Euler-Schritt)
    X_pos = X_pos + options.dt * interp2(X, Y, U, X_pos, Y_pos, 'linear', 0);  % Partikelposition in x-Richtung aktualisieren
    Y_pos = Y_pos + options.dt * interp2(X, Y, V, X_pos, Y_pos, 'linear', 0);  % Partikelposition in y-Richtung aktualisieren

    % Periodische Randbedingungen anwenden
    X_pos = mod(X_pos, options.x_max);
    Y_pos = mod(Y_pos, options.y_max);
end