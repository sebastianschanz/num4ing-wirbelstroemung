function Psi = poissonSolver(rhs, options)
    % Initialisierung des Druckfelds für die Poisson-Gleichung
    max_iter = 100;  % Maximale Anzahl an Iterationen zur Lösung der Poisson-Gleichung
    tol = 1e-12;  % Toleranz für das Abbruchkriterium
    Psi = zeros(size(rhs));
    for iter = 1:max_iter
        Psi_old = Psi;
        % Iterative Lösung der Poisson-Gleichung, um die 
        % Stromfunktion Psi aus der Wirbelstärke Omega zu berechnen
        Psi = 0.25 * (circshift(Psi, [1, 0]) + circshift(Psi, [-1, 0]) + circshift(Psi, [0, 1]) + circshift(Psi, [0, -1]) - rhs);
        Psi = applyBoundaryConditions(Psi, 'Dirichlet'); % Randbedingungen für Psi anwenden

        % Abbruchkriterium basierend auf der Konvergenz
        if max(max(abs(Psi - Psi_old))) < tol
            break;
        end
    end
end