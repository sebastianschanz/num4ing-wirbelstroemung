function Omega_dot = tgv_solveVorticity(U, V, Psi_bc, Omega, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, B, options)
    % Berechnung der Wirbelstärke ω zum nächsten Zeitpunkt mittels Wirbeltransportgleichung
    % unter Berücksichtigung von Diffusion und Konvektion.

    % Vektorisierung der Matrizen
    u = U(:); v = V(:); omega = Omega(:); psi_bc = Psi_bc(:);

    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * (D2x + D2y);

    if options.Aufwind == false
        % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
        convection = diag(u) * D1x + diag(v) * D1y;
    else
        % Konvektionsterm: Transport der Wirbelstärke durch die Strömung mit Aufwind-Verfahren
        up = max(u,0); um = min(u,0); vp = max(v,0); vm = min(v,0); 
        convection = diag(um) * D1xp + diag(up) * D1xm + diag(vm) * D1yp + diag(vp) * D1ym;
    end

    % Berechnung der Wirbelstärke
    omega_bc = (~B(:) .* omega) + B(:) .* (- (D2x + D2y) * psi_bc);

    % Berechnung der Wirbelstärkenänderung
    omega_dot = (diffusion - convection) * omega_bc;

    % Rücktransformation in Matrixform
    Omega_dot = reshape(omega_dot, [options.nx, options.ny]);
end

% Wirbelstärke (ω): Maß für die lokale Rotation in der Strömung. 
% Berechnet als Differenz der partiellen Ableitungen der Geschwindigkeitskomponenten.

% Advektion und Diffusion: In der Wirbelstärkentransportgleichung berücksichtigt. 
% Advektion beschreibt den Transport von Wirbelstärke durch die Strömung, während Diffusion die viskose Ausbreitung beschreibt.