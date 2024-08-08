function enstrophy = tgv_calcKinEnergy(Omega, options)
    % Diese Funktion berechnet die Enstrophie aus der Wirbelstärke.
    mu = options.mu;    dx = options.dx;    dy = options.dy;
    omega = Omega(:);
    
    % Integral über das Gebiet berechnen (Summe der quadratischen Wirbelstärke)
    enstrophy = -mu * sum(omega .^ 2) * dx * dy;
end