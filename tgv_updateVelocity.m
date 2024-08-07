function [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options, WH, WV)
    % Umrechnung der Stromfunktion Ψ in die einzelnen Geschwindigkeitskomponenten 
    % u und v anhand der Cauchy-Riemann-Gleichungen.

    % Vektorisierung der Matrizen
    psi = Psi(:); u = U(:); v = V(:);

    % Geschwindigkeiten U und V aus Psi
    u = ~WV(:) .* (D1y * psi) + WV(:) .* u; % u = ∂ψ/∂y
    v = ~WH(:) .* (-D1x * psi) + WH(:) .* v; % v = -∂ψ/∂x

    % Rücktransformation in Matrixform
    U = reshape(u, [options.nx, options.ny]);
    V = reshape(v, [options.nx, options.ny]);
end
