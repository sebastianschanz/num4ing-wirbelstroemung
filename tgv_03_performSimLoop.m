function tgv_03_performSimLoop(X, Y, Omega, options)
    % Hauptsimulationsschleife

    % Einmalige Initialisierung der Farben basierend auf den Y-Positionen
    colors = tgv_initColors(Y);

    time = linspace(0, options.t_end, options.t_nr); % Zeitdiskretisierung
    dt = time(2) - time(1); % Zeitschrittgröße
    X_pos = X; % Anfangsposition der Partikel in x-Richtung
    Y_pos = Y; % Anfangsposition der Partikel in y-Richtung
    X_pos_a = X; % Anfangsposition der Partikel in x-Richtung (analytisch)
    Y_pos_a = Y; % Anfangsposition der Partikel in y-Richtung (analytisch)

    % Erstellen eines Figure-Handles
    fig = figure;

    for t = time
        % Überprüfen, ob die Figur noch gültig ist
        if ~isvalid(fig)
            break;
        end

        % Berechnung der numerischen Stromfunktion
        Psi = tgv_poissonSolver(Omega);

        % Aktualisierung der Partikelpositionen (numerisch)
        [U, V] = tgv_updateVelocity(Psi);
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, dt, X, Y);

        % Aktualisierung der Wirbelstärke (numerisch)
        Omega = tgv_updateVorticity(U, V, Omega, options, dt);

        % Berechnung der analytischen Lösung
        [U_a, V_a, Psi_a] = tgv_computeAnalytical(X, Y, t, options.nu);
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a, V_a, dt, X, Y);

        % Plot der numerischen Lagrange-Partikel
        tgv_plotData(subplot(2, 2, 1), X_pos, Y_pos, colors, 'scatter', 'Lagrange Partikel (Numerisch)', 'x', 'y', '');

        % Plot der numerischen Stromfunktion
        tgv_plotData(subplot(2, 2, 2), X, Y, Psi, 'surf', 'Stromfunktion (Numerisch)', 'x', 'y', '$\Psi$');

        % Plot der analytischen Lagrange-Partikel
        tgv_plotData(subplot(2, 2, 3), X_pos_a, Y_pos_a, colors, 'scatter', 'Lagrange Partikel (Analytisch)', 'x', 'y', '');

        % Plot der analytischen Stromfunktion
        tgv_plotData(subplot(2, 2, 4), X, Y, Psi_a, 'surf', 'Stromfunktion (Analytisch)', 'x', 'y', '$\Psi$');

        % Hinzufügen eines Gesamttitels mit nu und Zeit
        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');

        drawnow;
    end

    % Schließen der Figur am Ende der Schleife
    if isvalid(fig)
        close(fig);
    end
end
