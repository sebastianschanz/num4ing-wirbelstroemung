function performSimLoop(X, Y, Omega, options, ax1, ax2)
    % Aktualisierungsschleife für die Simulation
    colors = initColors(Y);  % Farben für die Partikel initialisieren
    time = linspace(0, options.t_end, options.t_nr);  % Zeitdiskretisierung
    dt = time(2) - time(1);  % Zeitschrittgröße
    X_pos = X;  % Anfangsposition der Partikel in x-Richtung
    Y_pos = Y;  % Anfangsposition der Partikel in y-Richtung

    for t = time
        % 1. Plot der Lagrange-Partikel vor der Aktualisierung
        plotLagrangeParticles(ax1, X_pos, Y_pos, colors, options);

        % 2. Berechnung der Stromfunktion aus der Wirbelstärke
        Psi = poissonSolver(Omega);
        Psi = applyBoundaryConditions(Psi, 'Dirichlet'); % Randbedingungen für Psi anwenden

        % 3. Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion
        [U, V] = updateVelocity(Psi);

        % 4. Aktualisierung der Partikelpositionen
        [X_pos, Y_pos] = updatePosition(X_pos, Y_pos, U, V, dt, X, Y);

        % 5. Aktualisierung der Wirbelstärke (Wirbeltransportgleichung)
        Omega = updateVorticity(U, V, Omega, options, dt);
        Omega = applyBoundaryConditions(Omega, 'Dirichlet');  % Randbedingungen für Omega anwenden

        % 6. Plot der Stromfunktion nach der Aktualisierung
        plotStreamFunction(ax2, X, Y, Psi, options);

        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');  % Gesamttitel setzen
        drawnow;
    end
end