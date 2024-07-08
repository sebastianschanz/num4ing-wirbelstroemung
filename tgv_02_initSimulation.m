function [X, Y, Omega] = tgv_02_initSimulation(options)
    % Initialisierung der Simulationsvariablen
    x = linspace(0, 2*pi, options.x_nr);  % Diskretisierung in x-Richtung
    y = linspace(0, 2*pi, options.y_nr);  % Diskretisierung in y-Richtung
    [X, Y] = meshgrid(x, y);  % Erzeugung des Gitters
    Omega = 2 * sin(X) .* sin(Y); % Initiale Wirbelstärke
end