function [X, Y, Psi, Omega] = initSimulation(options)
    % Initialisierung der Simulationsvariablen
    x = linspace(0, 2*pi, options.x_nr);  % Diskretisierung in x-Richtung
    y = linspace(0, 2*pi, options.y_nr);  % Diskretisierung in y-Richtung
    [X, Y] = meshgrid(x, y);  % Erzeugung des Gitters
    Omega = -2*sin(X).*sin(Y);  % Anfangsbedingung für Wirbelstärke (Taylor-Green-Wirbel)
    Omega = applyBoundaryConditions(Omega, 'Dirichlet'); % Randbedingungen für Omega anwenden
    Psi = poissonSolver(Omega, options);  % Berechnung der Stromfunktion aus der Wirbelstärke
    Psi = applyBoundaryConditions(Psi, 'Dirichlet'); % Randbedingungen für Psi anwenden
end