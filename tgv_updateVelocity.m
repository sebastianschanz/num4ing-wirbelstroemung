function [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options)
    % Umrechnung der Stromfunktion Ψ in die einzelnen Geschwindigkeitskomponenten 
    % u und v anhand der Cauchy-Riemann-Gleichungen.

    % Vektorisierung der Matrizen
    psi = Psi(:); u = U(:); v = V(:);

    % Geschwindigkeiten U und V aus Psi
    u = ~W(:) .* (D1y * psi) + W(:) .* u; % u = ∂ψ/∂y
    v = ~W(:) .* (-D1x * psi) + W(:) .* v; % v = -∂ψ/∂x

    % Rücktransformation in Matrixform
    U = reshape(u, [options.nx, options.ny]);
    V = reshape(v, [options.nx, options.ny]);
end
