function tgv_03_performSimLoop(X, Y, Omega, options)
    % Hauptsimulationsschleife

    % Einmalige Initialisierung der Farben basierend auf den Y-Positionen
    colors = tgv_initColors(Y);

    time = linspace(0, options.t_end, options.t_nr); % Zeitdiskretisierung
    dt = options.t_end / options.t_nr; % Zeitschrittweite

    % Initialisierung der Partikelpositionen
    X_pos = X;
    Y_pos = Y;
    X_pos_a = X;
    Y_pos_a = Y;

    % Erstellung der Differenzmatrizen für die Ableitungen in x- und y-Richtung
    D1x = tgv_createD1Matrix(options.x_nr, options.y_nr, 'x');
    D1y = tgv_createD1Matrix(options.x_nr, options.y_nr, 'y');
    D2x = tgv_createD2Matrix(options.x_nr, options.y_nr, 'x');
    D2y = tgv_createD2Matrix(options.x_nr, options.y_nr, 'y');

    % Erstellen eines Figure-Handles für die Plots
    fig = figure;

    for t = time
        tic; % Start der Zeitmessung für einen Zeitschritt
        disp(['Aktueller Zeitschritt: ', num2str(t)]); % Debug-Ausgabe des aktuellen Zeitschritts

        % Überprüfen, ob die Figur noch gültig ist
        if ~isvalid(fig)
            break;
        end

        % Berechnung der numerischen Stromfunktion durch Lösung der Poisson-Gleichung
        Psi = tgv_poissonSolver(Omega, D2x, D2y);

        % Aktualisierung der Partikelpositionen (numerisch)
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, options); % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, dt, X, Y); % Aktualisierung der Partikelpositionen

        % Aktualisierung der Wirbelstärke (numerisch) unter Berücksichtigung von Diffusion und Konvektion
        Omega = tgv_updateVorticity(U, V, Omega, D1x, D1y, D2x, D2y, options, dt);

        % Berechnung der analytischen Lösung für die Geschwindigkeitskomponenten und die Stromfunktion
        [U_a, V_a, Psi_a] = tgv_computeAnalytical(X, Y, t, options.nu);
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a, V_a, dt, X, Y); % Aktualisierung der Partikelpositionen (analytisch)

        % Plot der numerischen Lösung (Lagrange-Partikel und Stromfunktion)
        tgv_plotData(subplot(2, 2, 1), X_pos, Y_pos, colors, 'scatter', 'Lagrange Partikel (Numerisch)', 'x', 'y', '');
        tgv_plotData(subplot(2, 2, 2), X, Y, Psi, 'surf', 'Stromfunktion (Numerisch)', 'x', 'y', '$\Psi$');

        % Plot der analytischen Lösung (Lagrange-Partikel und Stromfunktion)
        tgv_plotData(subplot(2, 2, 3), X_pos_a, Y_pos_a, colors, 'scatter', 'Lagrange Partikel (Analytisch)', 'x', 'y', '');
        tgv_plotData(subplot(2, 2, 4), X, Y, Psi_a, 'surf', 'Stromfunktion (Analytisch)', 'x', 'y', '$\Psi$');

        % Hinzufügen eines Gesamttitels mit Viskosität und Zeit
        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');

        drawnow; % Aktualisierung der Plots
        elapsedTime = toc; % Ende der Zeitmessung für einen Zeitschritt
        disp(['Berechnungszeit: ', num2str(elapsedTime), ' Sekunden']); % Debug-Ausgabe der Berechnungszeit
    end

    % Schließen der Figur am Ende der Schleife
    if isvalid(fig)
        close(fig);
    end
end
