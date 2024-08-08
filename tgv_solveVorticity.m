function Omega_dot = tgv_solveVorticity(U, V, Psi, Omega, D1x, D1y, D2x, D2y, B, options)
    % Berechnung der Wirbelstärke ω zum nächsten Zeitpunkt mittels Wirbeltransportgleichung
    % unter Berücksichtigung von Diffusion und Konvektion.

    % Vektorisierung der Matrizen
    u = U(:); v = V(:); omega = Omega(:); psi = Psi(:);

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * (D2x + D2y);

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = diag(u) * D1x + diag(v) * D1y;

    % Berechnung der Wirbelstärke
    omega_B = (~B(:) .* omega) + B(:) .* (- (D2x + D2y) * psi);

    % Berechnung der Wirbelstärkenänderung
    omega_dot = (diffusion - convection) * omega_B;

    % Rücktransformation in Matrixform
    Omega_dot = reshape(omega_dot, [options.nx, options.ny]);
end

% Wirbelstärke (ω): Maß für die lokale Rotation in der Strömung. 
% Berechnet als Differenz der partiellen Ableitungen der Geschwindigkeitskomponenten.

% Advektion und Diffusion: In der Wirbelstärkentransportgleichung berücksichtigt. 
% Advektion beschreibt den Transport von Wirbelstärke durch die Strömung, während Diffusion die viskose Ausbreitung beschreibt.