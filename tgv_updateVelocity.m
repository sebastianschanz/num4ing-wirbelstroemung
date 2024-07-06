function [U, V] = tgv_updateVelocity(Psi)
    % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion Psi
    [dPsidx, dPsidy] = gradient(Psi);  % Berechnung der Gradienten der Stromfunktion
    U = dPsidy;  % Geschwindigkeit U aus der Stromfunktion
    V = -dPsidx;  % Geschwindigkeit V aus der Stromfunktion
end