function options = tgv_configureSimulation()
    % Funktion zur Konfiguration der Simulationsparameter
    options.nu = 0.15; % Kinematische Viskosität
    options.rho = 1.0; % Dichte des Fluids
    options.mu = options.nu * options.rho; % Dynamische Viskosität
    options.nx = 50; % Anzahl der Gitterpunkte in x-Richtung
    options.ny = 50; % Anzahl der Gitterpunkte in y-Richtung

    % Intervallgrenzen 
    % Partikelplot, Bahnlinien und Stromfunktion
    options.xMin = 0;
    options.xMax = 2 * pi;
    options.yMin = 0;
    options.yMax = 2 * pi;
    options.zMin = -1;
    options.zMax = 1;
    % Positionsfehler
    options.posMin = 0;
    options.posMax = 0.1;
    % Energie und Enstrophieplot
    options.ensMin = -10;
    options.ensMax = 10;
    
    % Gitterabstände in x- und y-Richtung
    options.dx = (options.xMax - options.xMin) / (options.nx - 1);
    options.dy = (options.yMax - options.yMin) / (options.nx - 1);

    % Endzeit, Anzahl der Zeitschritte und Zeitschrittweite
    options.tEnd = 8;                      % Endzeit der Simulation
    options.dt = 0.03;                      % Initiale Zeitschrittweite. Wird im Verlauf der Simulation überschrieben.
    options.dynamicTimeSteps = true;        % Dynamische Zeitschrittweitensteuerung aktivieren
    options.maxIters = 1000;                % Maximale Iterationsanzahl. Betrifft die Speichervorreservierung für die Ergebnisarrays
    options.cfl = 0.3;                      % Zielwert CFL-Zahl für die Zeitschrittweitensteuerung
    options.stepMethod = 'Heun';            % Methode für Schrittverfahren: 'Expliziter Euler', 'Heun', 'Runge-Kutta 4'
 
    options.calcErrors = true;              % Fehlerberechnung aktivieren
    options.showPsiMax = true;                % Maximalwert der Stromfunktion anzeigen
    options.writeGif = false;               % GIF-Datei schreiben
    options.colormap = 'parula';            % Farbschema für Plots
    options.nticks = 3;                     % Anzahl der Ticks auf Achsenen
    options.imgWidth = 400;                 % Bildbreite
    options.imgHeight = options.imgWidth;   % Bildhöhe
    options.fontSize = 8;                   % Grund-Schriftgröße
    options.imgScale = 1.5;                 % 1-1.8, Skalierungsfaktor für Bildauflösung, hochschrauben für schönere Gifs
    options.filename = sprintf('.\\export\\tgv_simulation_%s_nu%.2f_t%d_dts%d.gif', ...
                                options.stepMethod, options.nu, options.tEnd, options.dynamicTimeSteps);
end