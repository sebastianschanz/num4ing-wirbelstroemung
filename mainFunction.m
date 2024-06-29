%%% Projekt Wirbelströmung %%%
%%% TAYLOR-GREEN-WIRBEL %%%

%%% Gruppe nm Y
%%% Fabian Schmitt 492849, 
%%% Leon Benjamin Wagner 498829, 
%%% Sebastian Schanz 482121,
%%% Tristan Johannes Schefold 489395

function main()
    % Hauptfunktion zur Initialisierung und Ausführung der Taylor-Green-Wirbel-Simulation
    options = configureSimulation();  % Simulationsparameter setzen
    [X, Y, Psi, Omega] = initSimulation(options);  % Simulationsvariablen initialisieren
    [ax1, ax2] = initPlots(X, Y, Psi, options);  % Plots initialisieren
    performSimLoop(X, Y, Omega, options, ax1, ax2);  % Aktualisierungsschleife ausführen
end

main();

% Nächste Schritte:
% Numerische Verfahren: Sobald die pBerechnung des Taylor-Green-Wirbels korrekt ist, können verschiedene numerische Verfahren getestet werden. Dies könnte durch die Implementierung verschiedener Diskretisierungs- und Zeitschrittverfahren erfolgen (z.B. expliziter Euler, Runge-Kutta, Adams-Bashforth).
% Validierung: Die Ergebnisse sollten mit analytischen Lösungen oder anderen verifizierten numerischen Ergebnissen verglichen werden, um sicherzustellen, dass die Implementierung korrekt ist.
% Visualisierung: Zusätzliche Visualisierungen können hinzugefügt werden, um die Ergebnisse besser zu interpretieren und zu analysieren.
