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
    [X, Y, Psi, Omega] = tgv_02_initSimulation(options);  % Simulationsvariablen initialisieren
    [ax1, ax2] = tgv_03_initPlots(X, Y, Psi, options);  % Plots initialisieren
    tgv_04_performSimLoop(X, Y, Omega, options, ax1, ax2);  % Aktualisierungsschleife ausführen
    tgv_05_perfomAnalyticalSolution(X, Y, options);
end

main();