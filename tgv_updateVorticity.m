function Omega = tgv_updateVorticity(U, V, Omega, D1x, D1y, D2x, D2y, options, dt)
    % Diese Funktion aktualisiert die Wirbelstärke Omega basierend auf der
    % Wirbeltransportgleichung und unter Berücksichtigung von Konvektion
    % und Diffusion.

    % Berechnung der neuen Wirbelstärke mithilfe der Wirbeltransportgleichung
    % unter Berücksichtigung von Konvektion und Diffusion
    dOmegadx = D1x * Omega(:);
    dOmegady = D1y * Omega(:);
    laplacian_Omega = D2x * Omega(:) + D2y * Omega(:);

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = U(:) .* dOmegadx + V(:) .* dOmegady;

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * laplacian_Omega;

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    Omega = Omega(:) + dt * (diffusion - convection);

    % Rücktransformation in Matrixform
    Omega = reshape(Omega, [options.x_nr, options.y_nr]);

    % Ensure periodic boundary conditions for vorticity matrix
    Omega(:, 1) = Omega(:, end-1);
    Omega(:, end) = Omega(:, 2);
    Omega(1, :) = Omega(end-1, :);
    Omega(end, :) = Omega(2, :);
end
