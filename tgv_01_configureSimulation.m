function options = tgv_01_configureSimulation()
    % Defintion der Simulationsparameter
    options = struct( ...
        'nu', 0.1, ...                % Kinematische Viskosität
        't_end', 5, ...                % Endzeit der Simulation
        't_nr', 100, ...               % Anzahl der Zeitschritte
        'x_nr', 100, ...               % Anzahl der Gitterpunkte in x-Richtung
        'y_nr', 100, ...               % Anzahl der Gitterpunkte in y-Richtung
        'method', 'expliziter-euler', ...  % Integrationsmethode
        'colormap', 'parula', ...      % Colormap für die Plots
        'U_Wand', [0, 0, 0, 0] ...     % Wandgeschwindigkeiten
    );
end
