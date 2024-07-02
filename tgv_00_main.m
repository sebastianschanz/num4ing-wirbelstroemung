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
    [X, Y, Omega] = tgv_02_initSimulation(options);  % Simulationsvariablen initialisieren
    tgv_03_performSimLoop(X, Y, Omega, options);  % Aktualisierungsschleife ausführen
end

main();