function tgv_performSimLoop(data, options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    X = data.X; Y = data.Y; X_pos = data.X_pos; Y_pos = data.Y_pos; X_pos_a = data.X_pos_a; Y_pos_a = data.Y_pos_a;
    D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; B = data.B; W = data.W; A_L = data.A_L; A_U = data.A_U;
    traj_X_pos = data.traj_X_pos; traj_Y_pos = data.traj_Y_pos; traj_X_pos_a = data.traj_X_pos_a; traj_Y_pos_a = data.traj_Y_pos_a; particleIndices = data.particleIndices;
    U = data.U; V = data.V; Psi = data.Psi; Omega = data.Omega; U_a = data.U_a; V_a = data.V_a; Psi_a = data.Psi_a; colors = data.colors;
    fig = data.fig; WH = data.WH; WV = data.WV;

    for i = 1:length(time)
        if ~isvalid(fig) % Prüfen, ob die Figure noch existiert
            break;
        end
        t = time(i);
        tic;
        clf(fig); % Figure löschen, bevor neuer Frame gezeichnet wird

        %%%%%%% ANALYTISCHE LÖSUNG %%%%%%%
        % Analytische Lösung für t aktualisieren
        U_a_now = U_a(t); V_a_now = V_a(t); Psi_a_now = Psi_a(t);

        % Partikelpositionen der analytischen Lösung aktualisieren
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a_now, V_a_now, X, Y, options);

        %%%%%%% NUMERISCHE LÖSUNG %%%%%%%
        % 1. Mit Wirbelstärke ω Poisson-Gleichung lösen, um die Stromfunktion ψ zu aktualisieren
        Psi = tgv_updateStream(Omega, A_L, A_U, Psi, B);

        % 2. Geschwindigkeitsfeld U und V aktualisieren
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options, WH, WV);

        % 3. Wirbelstärke ω aktualisieren
        Omega = tgv_updateVorticity(U, V, Omega, Psi, D1x, D1y, D2x, D2y, W, options);

        % 4. Partikelpositionen aktualisieren
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options);

        % Analytische und Numerische Lösung plotten
        tgv_plotStreamFunction(subplot(2, 3- ~options.calcErrors, 4 - ~options.calcErrors, 'Parent', fig), X, Y, Psi, 'Stromfunktion $\Psi_n$ (num.)', 'x', 'y', '$\Psi_n$', options);
        tgv_plotStreamFunction(subplot(2, 3 - ~options.calcErrors, 5 - ~options.calcErrors, 'Parent', fig), X, Y, Psi_a_now, 'Stromfunktion $\Psi_a$ (ana.)', 'x', 'y', '$\Psi_a$', options);

        if options.showTraj
            % Bahnlinien der ausgewählten Partikel aktualisieren
            for j = 1:options.numParticles
                idx = particleIndices(j);
                traj_X_pos{j} = [traj_X_pos{j}, X_pos(idx)];
                traj_Y_pos{j} = [traj_Y_pos{j}, Y_pos(idx)];
                traj_X_pos_a{j} = [traj_X_pos_a{j}, X_pos_a(idx)];
                traj_Y_pos_a{j} = [traj_Y_pos_a{j}, Y_pos_a(idx)];
            end
            % Plotten der Trajektorien auf die leeren Felder
            tgv_plotTrajectories(subplot(2, 3 - ~options.calcErrors, 1, 'Parent', fig), traj_X_pos, traj_Y_pos, 'Bahnlinien (num.)', 'x', 'y', options);
            tgv_plotTrajectories(subplot(2, 3 - ~options.calcErrors, 2, 'Parent', fig), traj_X_pos_a, traj_Y_pos_a, 'Bahnlinien (ana.)', 'x', 'y', options);
        else
            tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 1, 'Parent', fig), X_pos, Y_pos, colors, 'Lagrange-Partikel (num.)', 'x', 'y', options);
            tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 2, 'Parent', fig), X_pos_a, Y_pos_a, colors, 'Lagrange-Partikel (ana.)', 'x', 'y', options);
        end 

        if options.calcErrors
            % 5. Fehler der analytischen und numerischen Lösung berechnen
            [pos_err_abs, Psi_err, Psi_mse_err] = tgv_calcErrors(X_pos, Y_pos, X_pos_a, Y_pos_a, Psi, Psi_a_now);

            % Erstellt einen Boxplot der absoluten Positionsfehler
            pos_err_std = tgv_plotErrors(subplot(2, 3, 3, 'Parent', fig), pos_err_abs, 'Positionsfehler $|pos_{err}|$', options);
            text(subplot(2, 3, 3, 'Parent', fig), 0, -0.23, ['STD $|pos_{err}|$: ', sprintf('%.7f', pos_err_std)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');

            % Erstellt einen Plot der Fehler der Stromfunktion
            tgv_plotStreamFunction(subplot(2, 3, 6, 'Parent', fig), X, Y, Psi_err, 'Differenz $\Psi_{err}=\Psi_{n}-\Psi_{a}$', 'x', 'y', '$\Psi_{err}$', options, 'autumn', [], [], [-1*options.nu 1*options.nu]);
            text(subplot(2, 3, 6, 'Parent', fig), 0, -0.23, ['MSE $\Psi_{err}$: ', sprintf('%.8f', Psi_mse_err)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');
        end

        % Titel für die Figure aktualisieren
        sgtitle(['Taylor-Green-Wirbel mit ', '$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex', 'FontSize', options.imgScale*(options.fontSize+5));

        drawnow; % Plot aktualisieren
        if options.writeGif
            tgv_writeGifFrame(fig, 0.1, t, options); % GIF-Frame schreiben
        end

        elapsedTime = toc; % Berechnungsdauer stoppen
        disp([num2str(t, '%.2f'), ' von ', num2str(options.t_end, '%.2f'), ' s, Speed: ', num2str(elapsedTime, '%.2f'), ' s']);
    end

    if isvalid(fig)
        close(fig);
    end
end
