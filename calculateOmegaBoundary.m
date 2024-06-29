function Omega = calculateOmegaBoundary(Omega, Psi, nx, ny, h)
    % Randbedingungen für Omega setzen basierend auf Psi
    Omega(:, 1) = -2 * Psi(:, 2) / h^2;
    Omega(:, end) = -2 * Psi(:, end-1) / h^2;
    Omega(1, :) = -2 * Psi(2, :) / h^2;
    Omega(end, :) = -2 * Psi(end-1, :) / h^2;
end