function Omega = tgv_updateVorticity(U, V, Omega, options, Psi, dt)
    % Erzeugung des Boolschen Vektors W
    W = ones(options.x_nr, options.y_nr); W(2:end-1, 2:end-1) = 0;
    w = W(:);
    
    % Berechnung der neuen Wirbelstärke mithilfe der Wirbeltransportgleichung
    % unter Berücksichtigung von Konvektion und Diffusion
    [dOmegadx, dOmegady] = gradient(Omega);  % Gradienten der Wirbelstärke
    laplacian_Omega = del2(Omega); % Laplace-Operator der Wirbelstärke

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = U .* dOmegadx + V .* dOmegady;

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * laplacian_Omega;

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    % Omega = Omega + dt * (diffusion - convection);
    Omega = reshape(Omega(:) + dt * (diffusion(:) - convection(:)).*(~w .* Omega(:) + w .* (-(laplacian_Omega(:)) .*Psi(:))),[options.x_nr, options.y_nr]);

end