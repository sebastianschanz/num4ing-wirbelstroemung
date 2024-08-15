function enstrophy = tgv_calcEnergy(Omega, options)
    % Diese Funktion berechnet die Enstrophie aus der Wirbelstärke.
    dx = options.dx;    dy = options.dy;
    omega = Omega(:);   mu = options.mu;
    % Integral über das Gebiet berechnen (Summe der quadratischen Wirbelstärke)
    enstrophy = -mu * sum(omega .^ 2) * dx * dy;
end