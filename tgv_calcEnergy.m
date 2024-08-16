function [energy, enstrophy] = tgv_calcEnergy(Omega, U, V, options)
    % Diese Funktion berechnet die Enstrophie aus der Wirbelstärke.
    dx = options.dx;    dy = options.dy;
    mu = options.mu;    rho = options.rho;
    omega = Omega(:); u = U(:); v = V(:);
    % Integral über das Gebiet berechnen (Summe der quadratischen Wirbelstärke)
    enstrophy = -mu * sum(omega .^ 2) * dx * dy;
    energy = rho / 2 * sum(u .^ 2 + v .^ 2) * dx * dy;
    disp(energy);
end