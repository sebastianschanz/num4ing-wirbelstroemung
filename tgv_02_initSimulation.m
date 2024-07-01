function [X, Y, Psi_0, Omega_0] = tgv_02_initSimulation(options)
    % Initialisierung der Simulationsvariablen
    x = linspace(0, 2*pi, options.x_nr);  % Diskretisierung in x-Richtung
    y = linspace(0, 2*pi, options.y_nr);  % Diskretisierung in y-Richtung
    [X, Y] = meshgrid(x, y);  % Erzeugung des Gitters
    F = 1;
    Omega_0 = 2*sin(X).*sin(Y)*exp()*F;
    Omega_0 = tgv_applyBoundaryConditions(Omega_0, 'Dirichlet'); % Randbedingungen für Omega anwenden
    Psi_0 = tgv_poissonSolver(Omega_0);  % Berechnung der Stromfunktion aus der Wirbelstärke
    Psi_0 = tgv_applyBoundaryConditions(Psi_0, 'Dirichlet'); % Randbedingungen für Psi anwenden
end