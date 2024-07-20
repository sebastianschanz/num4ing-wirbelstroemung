function tgv_03_performSimLoop(X, Y, U_a, V_a, Psi_a, B, W, options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation
    colors = tgv_initColors(Y, options); % Farben für die Partikel initialisieren
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    % Partikelpositionen initialisieren
    X_pos = X;   Y_pos = Y;   X_pos_a = X;   Y_pos_a = Y;

    % Initialisierung der Bahnlinie eines Partikels
    traj_X_pos = [];   traj_Y_pos = [];  traj_X_pos_a = [];   traj_Y_pos_a = [];

    % Erstellen der Ableitungsmatrizen D1x, D1y, D2x und D2y
    [D1x, D1y] = tgv_createNabla(options);
    [D2x, D2y] = tgv_createLaplace(options);

    % Aufstellen und Zerlegen der Systemmatrix für die Poisson-Gleichung
    A = diag(~B(:)) * (D2x + D2y) + diag(B(:)); % ∇² = ∂²/∂x² + ∂²/∂y²
    [A_L, A_U] = lu(A);                         % LU-Zerlegung der Systemmatrix

    % Numerische Lösung mit analytischer vorinitialisieren
    U = U_a(0);                                 % U = sin(X) .* cos(Y) * F_t
    V = V_a(0);                                 % V = -cos(X) .* sin(Y) * F_t
    Psi = Psi_a(0);                             % ψ = sin(X) .* sin(Y) * F_t
    Omega_vec = -(D2x * Psi(:) + D2y * Psi(:)); % ω = -∇²ψ  
    Omega = reshape(Omega_vec, size(X));        % in Matrix umwandeln

    % Figure für die Animation erstellen
    if options.calcErrors
        fig = figure('Position', [100, 100, 500, 700]); % Größere Figure bei Fehlerberechnung
    else
        fig = figure('Position', [100, 100, 500, 400]); % Standardgröße
    end

    if options.writeGif
        set(fig, 'Visible', 'off'); % Figure unsichtbar machen;
        isFirstFrame = true; % Erster Frame für GIF-Datei
    end

    for i = 1:length(time)
        t = time(i);
        tic;
        disp(['Aktueller Zeitschritt: ', num2str(t)]); % Aktuellen Zeitschritt ausgeben

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
        
        if options.showTraj
            % Bahnlinie des ausgewählten Partikels aktualisieren
            traj_X_pos = [traj_X_pos, X_pos(options.particleIdx)]; % X-Position des ausgewählten Partikels hinzufügen
            traj_Y_pos = [traj_Y_pos, Y_pos(options.particleIdx)]; % Y-Position des ausgewählten Partikels hinzufügen
            traj_X_pos_a = [traj_X_pos_a, X_pos_a(options.particleIdx)]; % X-Position des ausgewählten Partikels hinzufügen
            traj_Y_pos_a = [traj_Y_pos_a, Y_pos_a(options.particleIdx)]; % Y-Position des ausgewählten Partikels hinzufügen
            tgv_plotTrajectory(subplot(3, 2, 1, 'Parent', fig), traj_X_pos, traj_Y_pos,X_pos(options.particleIdx), Y_pos(options.particleIdx));
            tgv_plotTrajectory(subplot(3, 2, 3, 'Parent', fig), traj_X_pos_a, traj_Y_pos_a, X_pos_a(options.particleIdx), Y_pos_a(options.particleIdx));
        end 

        if options.calcErrors
            % 5. Fehler der analytischen und numerischen Lösung berechnen
            [pos_err_abs, Psi_err, Psi_mse_err] = tgv_calcErrors(X_pos, Y_pos, X_pos_a, Y_pos_a, Psi, Psi_a_now);

            % Erstellt einen Boxplot der absoluten Fehler and Subplotposition 5
            pos_err_std = tgv_plotErrors(subplot(3, 2, 5, 'Parent', fig), pos_err_abs, t, 'Absolute Positionsfehler', '$|pos_{error}|$', options);
            text(subplot(3, 2, 5, 'Parent', fig), 0, -0.2, ['STD Position: ', num2str(pos_err_std)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', 12, 'Interpreter', 'latex');

            % tgv_writeErrors(subplot(3, 2, 5, 'Parent', fig), X_error, Y_error, mse_error_Psi, 'Error-Psi MSE');
            tgv_plotStreamFunction(subplot(3, 2, 6, 'Parent', fig), X, Y, Psi_err, '$\Psi_{error} = \Psi_n - \Psi_a$', 'x', 'y', '$\Psi_{error}$', options, 'autumn', [], [], [-1*options.nu 1*options.nu]);
            % Add the updating text to subplot 6
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
        end
        elapsedTime = toc; % Berechnungszeit für Zeitschritt speichern
        disp(['Berechnungszeit: ', num2str(elapsedTime), ' Sekunden']); % Berechnungszeit ausgeben
    end

    if isvalid(fig)
        close(fig);
    end
end
