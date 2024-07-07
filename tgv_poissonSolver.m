function Psi = tgv_poissonSolver(Omega, options)
    % Erzeugung des Boolschen Vektors B
    B = ones(options.x_nr, options.y_nr); B(2:end-1, 2:end-1) = 0;

    % Initialisierung des Druckfelds für die Poisson-Gleichung
    max_iter = 100;  % Maximale Anzahl an Iterationen zur Lösung der Poisson-Gleichung
    tol = 1e-12;  % Toleranz für das Abbruchkriterium
    Psi = zeros(size(Omega)); % Initialisierung des Druckfelds Psi
    for iter = 1:max_iter
        Psi_old = Psi;
        % Iterative Lösung der Poisson-Gleichung, um die 
        % Stromfunktion Psi aus der Wirbelstärke Omega zu berechnen
        Psi = 0.25 * (circshift(Psi, [1, 0]) + circshift(Psi, [-1, 0]) + circshift(Psi, [0, 1]) + circshift(Psi, [0, -1]) - Omega);
        Psi = tgv_applyBoundaryConditions(Psi, 'Dirichlet'); % Randbedingungen für Psi anwenden

        % % Psi_Rand bestimmen aus Randbedingungen
        % Psi_Rand = 0;

        % psi = (diag(~B(:)) * (del2(Omega(:)) + diag(B(:))))\ (~B(:).* (- Omega(:)) + B(:) .* Psi_Rand);
        % Psi = reshape(psi ,[options.x_nr, options.y_nr]);

        % Abbruchkriterium basierend auf der Konvergenz
        if max(max(abs(Psi - Psi_old))) < tol
            break;
        end
    end
end