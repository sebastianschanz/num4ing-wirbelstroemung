function options = tgv_configureSimulation()
    % Funktion zur Konfiguration der Simulationsparameter
    options.nu = 0.05; % Kinematische Viskosität
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
    options.t_end = 8;
    options.t_nr = options.t_end*20;
    options.dt = options.t_end / options.t_nr;
    options.method = 'expliziter-euler';    % Integrationsmethode
 
    options.calcErrors = false;             % Fehlerberechnung aktivieren
    options.showTraj = false;               % Bahnlinie eines Partikels anzeigen
    options.numParticles = 15;              % Startindex für die Partikel
    
    options.writeGif = false;               % GIF-Datei schreib
    options.colormap = 'parula';            % Farbkarte für die Darstellung
    options.nticks = 3;                     % Anzahl der Ticks auf Achsenen
    options.imgWidth = 400;                 % Bildbreite
    options.imgHeight = options.imgWidth;   % Bildhöhe
    options.fontSize = 8;                   % Grund-Schriftgröße
    options.imgScale = 1;                   % 1-1.8, Skalierungsfaktor für Bildauflösung, hochschrauben für schönere Gifs
    options.filename = '.\simulation_trajectories_15_nu_0.05.gif'; % Dateiname für die GIF-Datei
end