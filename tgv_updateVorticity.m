function Omega = tgv_updateVorticity(U, V, Omega, Psi, D1x, D1y, D2x, D2y, W, options)
    % Berechnung der Wirbelstärke ω zum nächsten Zeitpunkt mittels Wirbeltransportgleichung
    % unter Berücksichtigung von Diffusion und Konvektion.

    % Vektorisierung der Matrizen
    u = U(:); v = V(:); omega = Omega(:); psi = Psi(:);

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * (D2x + D2y);

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = diag(u) * D1x + diag(v) * D1y;

    % Berechnung der Wirbelstärke
    omega_W = (~W(:) .* omega) + W(:) .* (- (D2x + D2y) * psi);

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    omega = omega + options.dt * (diffusion - convection) * omega_W;

    % Rücktransformation in Matrixform
    Omega = reshape(omega, [options.nx, options.ny]);
end

% Wirbelstärke (ω): Maß für die lokale Rotation in der Strömung. 
% Berechnet als Differenz der partiellen Ableitungen der Geschwindigkeitskomponenten.

% Advektion und Diffusion: In der Wirbelstärkentransportgleichung berücksichtigt. 
% Advektion beschreibt den Transport von Wirbelstärke durch die Strömung, während Diffusion die viskose Ausbreitung beschreibt.