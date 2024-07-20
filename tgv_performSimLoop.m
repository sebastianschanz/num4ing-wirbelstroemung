function tgv_performSimLoop(options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    [data] = tgv_initSimulation(options);  % Simulationsvariablen initialisieren
    X = data.X; Y = data.Y; X_pos = data.X_pos; Y_pos = data.Y_pos; X_pos_a = data.X_pos_a; Y_pos_a = data.Y_pos_a;
    D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; B = data.B; W = data.W; A_L = data.A_L; A_U = data.A_U;
    traj_X_pos = data.traj_X_pos; traj_Y_pos = data.traj_Y_pos; traj_X_pos_a = data.traj_X_pos_a; traj_Y_pos_a = data.traj_Y_pos_a;
    U = data.U; V = data.V; Psi = data.Psi; Omega = data.Omega; U_a = data.U_a; V_a = data.V_a; Psi_a = data.Psi_a; colors = data.colors;

    % Figure für die Animation erstellen
    if options.calcErrors
        fig = figure('Position', [540, 50, 500, 700]); % Größere Figure bei Fehlerberechnung
    else
        fig = figure('Position', [540, 0, 500, 400]); % Standardgröße
    end

    if options.writeGif
        set(fig, 'Visible', 'off'); % Figure unsichtbar machen;
        isFirstFrame = true;        % Erster Frame für GIF-Datei
        hWaitbar = waitbar(0, 'Simulation läuft...'); % Fortschrittsanzeige erstellen
    end

    for i = 1:length(time)
        t = time(i);
        tic;

        if ~isvalid(fig)
            break;
        end

        %%%%%%% ANALYTISCHE LÖSUNG %%%%%%%
        % Analytische Lösung für t aktualisieren
        U_a_now = U_a(t); V_a_now = V_a(t); Psi_a_now = Psi_a(t);

        % Partikelpositionen der analytischen Lösung aktualisieren
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a_now, V_a_now, X, Y, options);

        %%%%%%% NUMERISCHE LÖSUNG %%%%%%%
        % 1. Mit Wirbelstärke ω Poisson-Gleichung lösen, um die Stromfunktion ψ zu aktualisieren
        Psi = tgv_updateStream(Omega, A_L, A_U, Psi, B);

        % 2. Geschwindigkeitsfeld U und V aktualisieren
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options);

        % 3. Wirbelstärke ω aktualisieren
        Omega = tgv_updateVorticity(U, V, Omega, Psi, D1x, D1y, D2x, D2y, W, options);

        % 4. Partikelpositionen aktualisieren
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options);
        X_pos = tgv_applyBC(X_pos, 'periodic');
        Y_pos = tgv_applyBC(Y_pos, 'periodic');

        % Analytische und Numerische Lösung plotten
        tgv_plotParticleField(subplot(3 - ~options.calcErrors, 2, 1, 'Parent', fig), X_pos, Y_pos, colors, 'Partikelplot (Numerisch)', 'x', 'y', options);
        tgv_plotStreamFunction(subplot(3 - ~options.calcErrors, 2, 2, 'Parent', fig), X, Y, Psi, 'Stromfkt. $\Psi_n$ (Numerisch)', 'x', 'y', '$\Psi_n$', options);
        tgv_plotParticleField(subplot(3 - ~options.calcErrors, 2, 3, 'Parent', fig), X_pos_a, Y_pos_a, colors, 'Partikelplot (Analytisch)', 'x', 'y', options);
        tgv_plotStreamFunction(subplot(3 - ~options.calcErrors, 2, 4, 'Parent', fig), X, Y, Psi_a_now, 'Stromfkt. $\Psi_a$ (Analytisch)', 'x', 'y', '$\Psi_a$', options);
        
        if options.showTraj && options.calcErrors
            % Bahnlinie des ausgewählten Partikels aktualisieren
            traj_X_pos = [traj_X_pos, X_pos(options.particleIdx)];          % X-Position des ausgewählten Partikels hinzufügen
            traj_Y_pos = [traj_Y_pos, Y_pos(options.particleIdx)];          % Y-Position des ausgewählten Partikels hinzufügen
            traj_X_pos_a = [traj_X_pos_a, X_pos_a(options.particleIdx)];    % X-Position des ausgewählten Partikels hinzufügen
            traj_Y_pos_a = [traj_Y_pos_a, Y_pos_a(options.particleIdx)];    % Y-Position des ausgewählten Partikels hinzufügen
            tgv_plotTrajectory(subplot(3, 2, 1, 'Parent', fig), traj_X_pos, traj_Y_pos,X_pos(options.particleIdx), Y_pos(options.particleIdx));
            tgv_plotTrajectory(subplot(3, 2, 3, 'Parent', fig), traj_X_pos_a, traj_Y_pos_a, X_pos_a(options.particleIdx), Y_pos_a(options.particleIdx));
        end 

        if options.calcErrors
            % 5. Fehler der analytischen und numerischen Lösung berechnen
            [pos_err_abs, Psi_err, Psi_mse_err] = tgv_calcErrors(X_pos, Y_pos, X_pos_a, Y_pos_a, Psi, Psi_a_now);

            % Erstellt einen Boxplot der absoluten Positionsfehler
            pos_err_std = tgv_plotErrors(subplot(3, 2, 5, 'Parent', fig), pos_err_abs, t, 'Absolute Positionsfehler', '$|pos_{error}|$', options);
            text(subplot(3, 2, 5, 'Parent', fig), 0, -0.2, ['STD Position: ', num2str(pos_err_std)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', 12, 'Interpreter', 'latex');

            % Erstellt einen Plot der Fehler der Stromfunktion
            tgv_plotStreamFunction(subplot(3, 2, 6, 'Parent', fig), X, Y, Psi_err, '$\Psi_{error} = \Psi_n - \Psi_a$', 'x', 'y', '$\Psi_{error}$', options, 'autumn', [], [], [-1*options.nu 1*options.nu]);
            text(subplot(3, 2, 6, 'Parent', fig), 0, -0.2, ['MSE von $\Psi$: ', num2str(Psi_mse_err)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', 12, 'Interpreter', 'latex');
        end

        % Titel für die Figure aktualisieren
        sgtitle(['Taylor-Green-Wirbel mit ', '$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex', 'FontSize', 15);

        drawnow; % Figure aktualisieren
        if options.writeGif
            tgv_writeGifFrame(fig, 0.1, isFirstFrame, options); % GIF-Frame schreiben
            isFirstFrame = false; % Erster Frame ist geschrieben
            waitbar(i / length(time), hWaitbar, sprintf('Fortschritt: %d%%', round(100 * i / length(time)))); % Fortschrittsanzeige aktualisieren
        end

        elapsedTime = toc; % Berechnungszeit für Zeitschritt speichern
        disp(['Berechnungszeit: ', num2str(elapsedTime), ' Sekunden']); % Berechnungszeit ausgeben
    end

    if isvalid(fig)
        close(fig);
    end
end
