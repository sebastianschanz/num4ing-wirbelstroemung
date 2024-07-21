%%% Projekt Wirbelströmung %%%
%%% TAYLOR-GREEN-VORTEX %%%

%%% Gruppe nm Y
%%% Fabian Schmitt 492849, 
%%% Leon Benjamin Wagner 498829, 
%%% Sebastian Schanz 482121,
%%% Tristan Johannes Schefold 489395

function main()
    % Hauptfunktion zur Initialisierung und Ausführung der Taylor-Green-Wirbel-Simulation
    options = tgv_configureSimulation();  % Simulationsparameter setzen
    [data] = tgv_initSimulation(options);  % Simulationsvariablen initialisieren
    tgv_performSimLoop(data, options);  % Aktualisierungsschleife ausführen
end

main();

% Nächste Schritte:
% Numerische Verfahren: Sobald die Berechnung des Taylor-Green-Wirbels korrekt ist, können verschiedene numerische Verfahren getestet werden. Dies könnte durch die Implementierung verschiedener Diskretisierungs- und Zeitschrittverfahren erfolgen (z.B. expliziter Euler, Runge-Kutta, Adams-Bashforth).