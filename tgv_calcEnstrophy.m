function enstrophy = tgv_calcEnstrophy(Omega, options)
    % Diese Funktion berechnet die Enstrophie aus der Wirbelstärke.
    dx = options.dx;    dy = options.dy;
    omega = Omega(:);
    % Integral über das Gebiet berechnen (Summe der quadratischen Wirbelstärke)
    enstrophy = sum(omega .^ 2) * dx * dy;
end