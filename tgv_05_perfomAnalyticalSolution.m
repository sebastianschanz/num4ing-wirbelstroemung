function tgv_05_perfomAnalyticalSolution(X, Y, options)
    Psi0 = sin(X).*sin(Y);

    % Fenster zum Plot erzeugen
    [ax1, ax2] = tgv_03_initPlots(X, Y, Psi0, options);

    % Aktualisierungsschleife für die Simulation
    colors = tgv_initColors(Y);  % Farben für die Partikel initialisieren
    time = linspace(0, options.t_end, options.t_nr);  % Zeitdiskretisierung
    dt = time(2) - time(1);  % Zeitschrittgröße
    X_pos = X;  % Anfangsposition der Partikel in x-Richtung
    Y_pos = Y;  % Anfangsposition der Partikel in y-Richtung

    for t = time
        % 1. Plot der Lagrange-Partikel vor der Aktualisierung
        tgv_plotLagrangeParticles(ax1, X_pos, Y_pos, colors, options);

        % 2. Berechnung der Stromfunktion aus der Wirbelstärke
        Psi = sin(X).*sin(Y).*exp(-2*options.nu*t);

        % 3. Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion
        U = sin(X).*cos(Y).*exp(-2*options.nu*t);
        V = -cos(X).*sin(Y).*exp(-2*options.nu*t);

        % 4. Aktualisierung der Partikelpositionen
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, dt, X, Y);

        % 6. Plot der Stromfunktion nach der Aktualisierung
        tgv_plotStreamFunction(ax2, X, Y, Psi, options);

        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');  % Gesamttitel setzen
        drawnow;
    end
end