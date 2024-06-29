function [X_pos, Y_pos] = updatePosition(X_pos, Y_pos, U, V, dt, X, Y)
    % Detaillierte Berechnung der Partikelpositionen
    X_pos = X_pos + dt * interp2(X, Y, U, X_pos, Y_pos, 'linear', 0);  % Partikelposition in x-Richtung aktualisieren
    Y_pos = Y_pos + dt * interp2(X, Y, V, X_pos, Y_pos, 'linear', 0);  % Partikelposition in y-Richtung aktualisieren

    % Periodische Randbedingungen anwenden
    X_pos = mod(X_pos, 2*pi);
    Y_pos = mod(Y_pos, 2*pi);
end