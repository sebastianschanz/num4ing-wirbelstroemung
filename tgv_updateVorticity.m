function Omega = tgv_updateVorticity(U, V, Omega, D1x, D1y, D2x, D2y, options)
    % Umwandlung der Wirbelstärke in Vektorform
    omega = Omega(:);

    % Berechnung der Gradienten von omega
    domegadx = D1x * omega;
    domegady = D1y * omega;

    % Berechnung des Laplacians von omega
    laplacian_omega = D2x * omega + D2y * omega;

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = U(:) .* domegadx + V(:) .* domegady;

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * laplacian_omega;

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    omega = omega + options.dt * (diffusion - convection);

    % Rücktransformation in Matrixform
    Omega = reshape(omega, [options.x_nr, options.y_nr]);
end
