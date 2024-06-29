function [X, Y, Psi_0, Omega_0] = initSimulation(options)
    % Initialisierung der Simulationsvariablen
    x = linspace(0, 2*pi, options.x_nr);  % Diskretisierung in x-Richtung
    y = linspace(0, 2*pi, options.y_nr);  % Diskretisierung in y-Richtung
    [X, Y] = meshgrid(x, y);  % Erzeugung des Gitters
    Omega_0 = sin(X).*sin(Y);
    Omega_0 = applyBoundaryConditions(Omega_0, 'Dirichlet'); % Randbedingungen für Omega anwenden
    Psi_0 = poissonSolver(Omega_0);  % Berechnung der Stromfunktion aus der Wirbelstärke
    Psi_0 = applyBoundaryConditions(Psi_0, 'Dirichlet'); % Randbedingungen für Psi anwenden
end