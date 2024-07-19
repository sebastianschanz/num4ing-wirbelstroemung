function options = tgv_01_configureSimulation()
    % Funktion zur Konfiguration der Simulationsparameter
    options.nu = 0.01; % Kinematische Viskosität
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
    options.t_end = 5;
    options.t_nr = 100;
    options.dt = options.t_end / options.t_nr;
 
    options.method = 'expliziter-euler'; % Integrationsmethode
    options.colormap = 'parula';         % Colormap für die Plots
    options.writeGif = false;             % GIF-Datei schreiben
    options.filename = 'C:\Users\Sebastian\Documents\00-dev\num4ing\num4ing-wirbelstroemung\export\simulation.gif'; % Dateiname für die GIF-Datei
end