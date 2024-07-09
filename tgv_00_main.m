%%% Projekt Wirbelströmung %%%
%%% TAYLOR-GREEN-VORTEX %%%

%%% Gruppe nm Y
%%% Fabian Schmitt 492849, 
%%% Leon Benjamin Wagner 498829, 
%%% Sebastian Schanz 482121,
%%% Tristan Johannes Schefold 489395

function main()
    % Hauptfunktion zur Initialisierung und Ausführung der Taylor-Green-Wirbel-Simulation
    options = tgv_01_configureSimulation();  % Simulationsparameter setzen
    [X, Y, U_a, V_a, Psi_a] = tgv_02_initSimulation(options);  % Simulationsvariablen initialisieren
    tgv_03_performSimLoop(X, Y, U_a, V_a, Psi_a, options);  % Aktualisierungsschleife ausführen
end

main();

% Nächste Schritte:
% Numerische Verfahren: Sobald die Berechnung des Taylor-Green-Wirbels korrekt ist, können verschiedene numerische Verfahren getestet werden. Dies könnte durch die Implementierung verschiedener Diskretisierungs- und Zeitschrittverfahren erfolgen (z.B. expliziter Euler, Runge-Kutta, Adams-Bashforth).
% Validierung: Die Ergebnisse sollten mit analytischen Lösungen oder anderen verifizierten numerischen Ergebnissen verglichen werden, um sicherzustellen, dass die Implementierung korrekt ist.
% Visualisierung: Zusätzliche Visualisierungen können hinzugefügt werden, um die Ergebnisse besser zu interpretieren und zu analysieren.
