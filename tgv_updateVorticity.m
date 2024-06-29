function Omega = tgv_updateVorticity(U, V, Omega, options, dt)
    % Berechnung der neuen Wirbelstärke mithilfe der Wirbeltransportgleichung
    % unter Berücksichtigung von Konvektion und Diffusion
    [dOmegadx, dOmegady] = gradient(Omega);  % Gradienten der Wirbelstärke
    laplacian_Omega = del2(Omega); % Laplace-Operator der Wirbelstärke

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = U .* dOmegadx + V .* dOmegady;

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * laplacian_Omega;

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    Omega = Omega + dt * (diffusion - convection);
end