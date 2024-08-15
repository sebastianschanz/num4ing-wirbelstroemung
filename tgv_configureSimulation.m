function options = tgv_configureSimulation()
    % Funktion zur Konfiguration der Simulationsparameter
    options.nu = 0.05; % Kinematische Viskosität
    options.rho = 1.0; % Dichte des Fluids
    options.mu = options.nu * options.rho; % Dynamische Viskosität
    options.nx = 50; % Anzahl der Gitterpunkte in x-Richtung
    options.ny = 50; % Anzahl der Gitterpunkte in y-Richtung

    % Intervallgrenzen in x-, y- und z-Richtung
    options.x_min = 0;
    options.x_max = 2 * pi;
    options.y_min = 0;
    options.y_max = 2 * pi;
    options.z_min = -1;
    options.z_max = 1;
    
    % Gitterabstände in x- und y-Richtung
    options.dx = (options.x_max - options.x_min) / (options.nx - 1);
    options.dy = (options.y_max - options.y_min) / (options.nx - 1);

    % Endzeit, Anzahl der Zeitschritte und Zeitschrittweite
    options.t_end = 6;
    options.t_nr = options.t_end*20+1;
    options.dt = options.t_end / options.t_nr;
    options.stepMethod = 'heun';       % Methode für Schrittverfahren
    options.Aufwind = false;                     % Aufwind Methode Anwenden oder nicht
    options.max_iter = 100;                     % Maximale Anzahl von Iterationen für implizite Verfahren
    options.tol = 1e-6;                        % Toleranz für die Iteration der impliziten Verfahren
    % Schritt-Methoden: 'exEuler', 'heun', 'rk4'
 
    options.calcErrors = true;              % Fehlerberechnung aktivieren
    options.calcEnstrophy = true;           % Energieberechnung aktivieren
    options.calcCFL = true;                 % maximale CFL-Zahl berechnen
    options.showTraj = false;               % Bahnlinie eines Partikels anzeigen
    options.numParticles = 12;              % Startindex für die Partikel
    
    options.writeGif = false;                % GIF-Datei schreiben
    options.colormap = 'parula';            % Farbkarte für die Darstellung
    options.nticks = 3;                     % Anzahl der Ticks auf Achsenen
    options.imgWidth = 400;                 % Bildbreite
    options.imgHeight = options.imgWidth;   % Bildhöhe
    options.fontSize = 8;                   % Grund-Schriftgröße
    options.imgScale = 1.0;                   % 1-1.8, Skalierungsfaktor für Bildauflösung, hochschrauben für schönere Gifs
    options.filename = sprintf('.\\export\\simulation_%s_nu_%.2f_tend_%d.gif', ...
                                options.stepMethod, options.nu, options.t_end);
end