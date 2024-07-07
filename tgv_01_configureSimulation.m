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
        'U_Wand', [0, 0, 0, 0], ...     % Wandgeschwindigkeiten in  x-Richtung, u(x_a, y), u(x, y_b), u(x_b, y), u(x, y_a) 
        'V_Wand', [0, 0, 0, 0] ...     % Wandgeschwindigkeiten in y-Richtung, v(x_a, y), v(x, y_b), v(x_b, y), v(x, y_a) 
    );
end
