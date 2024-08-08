function tgv_performSimLoop(data, options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation
    dt = options.dt;
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    X = data.X; Y = data.Y; D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; B = data.B;
    X_n_trail = data.X_n_trail; Y_n_trail = data.Y_n_trail; X_a_trail = data.X_a_trail; Y_a_trail = data.Y_a_trail;
    particleIdx = data.particleIdx; A_L = data.A_L; A_U = data.A_U; U_a = data.U_a; V_a = data.V_a; Psi_a = data.Psi_a; 
    colors = data.colors; fig = data.fig; WH = data.WH; WV = data.WV;

    for i = 1:length(time)
        if ~isvalid(fig) % Prüfen, ob die Figure noch existiert
            break;
        end
        t = time(i);
        tic;
        clf(fig); % Figure löschen, bevor neuer Frame gezeichnet wird
        
        % Aktuelle Variablen initialisieren
        Psi_a_now = Psi_a(t); U_a_now = U_a(t); V_a_now = V_a(t); % Analytische Lösung aktualisieren
        if t == 0
            U_n_now = U_a(t);                                               % U = sin(X) .* cos(Y) * F_t
            V_n_now = V_a(t);                                               % V = -cos(X) .* sin(Y) * F_t
            Psi_n_now = Psi_a(t);                                           % ψ = sin(X) .* sin(Y) * F_t
            Omega_n_now = reshape(- (D2x + D2y) * Psi_n_now(:), size(X));   % ω = -∇²ψ
            Omega_dot_n_now = tgv_solveVorticity(U_n_now, V_n_now, Psi_n_now, Omega_n_now, D1x, D1y, D2x, D2y, B, options);
            X_n_now = X; Y_n_now = Y;
            X_a_now = X; Y_a_now = Y;
        else
            Omega_n_now = Omega_n_next; Omega_dot_n_now = Omega_dot_n_next; Psi_n_now = Psi_n_next; % Numerische Lösung für t aktualisieren     
            X_n_now = X_n_next; Y_n_now = Y_n_next; U_n_now = U_n_next; V_n_now = V_n_next;
            X_a_now = X_a_next; Y_a_now = Y_a_next;
        end

        % Plots für die numerische und analytische Lösung
        if options.showTraj
            % Bahnlinien der ausgewählten Partikel aktualisieren
            for j = 1:options.numParticles
                idx = particleIdx(j);
                X_n_trail{j} = [X_n_trail{j}, X_n_now(idx)];
                Y_n_trail{j} = [Y_n_trail{j}, Y_n_now(idx)];
                X_a_trail{j} = [X_a_trail{j}, X_a_now(idx)];
                Y_a_trail{j} = [Y_a_trail{j}, Y_a_now(idx)];
            end
            % Plotten der Trajektorien auf die leeren Felder
            tgv_plotTrajectories(subplot(2, 3 - ~options.calcErrors, 1, 'Parent', fig), X_n_trail, Y_n_trail, 'Bahnlinien (num.)', 'x', 'y', options);
            tgv_plotTrajectories(subplot(2, 3 - ~options.calcErrors, 2, 'Parent', fig), X_a_trail, Y_a_trail, 'Bahnlinien (ana.)', 'x', 'y', options);
        else
            tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 1, 'Parent', fig), X_n_now, Y_n_now, colors, 'Lagrange-Partikel (num.)', 'x', 'y', options);
            tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 2, 'Parent', fig), X_a_now, Y_a_now, colors, 'Lagrange-Partikel (ana.)', 'x', 'y', options);
        end
        tgv_plotStreamFunction(subplot(2, 3- ~options.calcErrors, 4 - ~options.calcErrors, 'Parent', fig), X, Y, Psi_n_now, 'Stromfunktion $\Psi_n$ (num.)', 'x', 'y', '$\Psi_n$', options);
        tgv_plotStreamFunction(subplot(2, 3 - ~options.calcErrors, 5 - ~options.calcErrors, 'Parent', fig), X, Y, Psi_a_now, 'Stromfunktion $\Psi_a$ (ana.)', 'x', 'y', '$\Psi_a$', options);

        %Wenn Option calcErrors oder calcEnergy aktiviert ist
        if options.calcErrors
            % 5. Fehler der analytischen und numerischen Lösung berechnen
            [pos_err_abs, Psi_err, psi_mse_err] = tgv_calcErrors(X_n_now, Y_n_now, X_a_now, Y_a_now, Psi_n_now, Psi_a_now);

            % Erstellt einen Boxplot der absoluten Positionsfehler
            pos_err_std = tgv_plotErrors(subplot(2, 3, 3, 'Parent', fig), pos_err_abs, 'Positionsfehler $|pos_{err}|$', options);
            text(subplot(2, 3, 3, 'Parent', fig), 0, -0.23, ['STD $|pos_{err}|$: ', sprintf('%.7f', pos_err_std)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');

            if options.calcEnergy
                % 6. Kinetische Energie berechnen
                Omega_a_now = reshape(- (D2x + D2y) * Psi_a_now(:), size(X)); % ω = -∇²ψ
                E_kin_n(i) = tgv_calcKinEnergy(Omega_n_now, options);
                E_kin_a(i) = tgv_calcKinEnergy(Omega_a_now, options);
                % Plot der kinetischen Energie
                tgv_plotKinEnergy(subplot(2, 3, 6, 'Parent', fig), time(1:i), E_kin_n, E_kin_a, options);
            else
                % Erstellt einen Plot der Fehler der Stromfunktion
                tgv_plotStreamFunction(subplot(2, 3, 6, 'Parent', fig), X, Y, Psi_err, 'Differenz $\Psi_{err}=\Psi_{n}-\Psi_{a}$', 'x', 'y', '$\Psi_{err}$', options, 'autumn', [], [], [-1*options.nu 1*options.nu]);
                text(subplot(2, 3, 6, 'Parent', fig), 0, -0.23, ['MSE $\Psi_{err}$: ', sprintf('%.8f', psi_mse_err)], ...
                    'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                    'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');
            end
        end

        % Aktualisierung der Strömungsgrößen für den nächsten Zeitschritt
        [Psi_n_next, U_n_next, V_n_next, Omega_dot_n_next] = tgv_updateVariables(Omega_n_now, Psi_n_now, U_n_now, V_n_now, D1x, D1y, D2x, D2y, WH, WV, A_L, A_U, B, options);

        % Zeitschrittverfahren für die numerische Lösung
        if strcmp(options.stepMethod, 'explicitEuler')
            Omega_n_next = Omega_n_now + dt * Omega_dot_n_now;
            X_n_next = X_n_now + dt * interp2(X, Y, U_n_now, X_n_now, Y_n_now, 'linear', 0);
            Y_n_next = Y_n_now + dt * interp2(X, Y, V_n_now, X_n_now, Y_n_now, 'linear', 0);
        elseif strcmp(options.stepMethod, 'trapezoid')
            Omega_n_next = Omega_n_now + dt * 0.5 * (Omega_dot_n_now + Omega_dot_n_next);
            X_n_next = X_n_now + dt * interp2(X, Y, U_n_now, X_n_now, Y_n_now, 'linear', 0);
            Y_n_next = Y_n_now + dt * interp2(X, Y, V_n_now, X_n_now, Y_n_now, 'linear', 0);
            X_n_next = X_n_now + dt * 0.5 * (interp2(X, Y, U_n_now, X_n_now, Y_n_now, 'linear', 0) + interp2(X, Y, U_n_next, X_n_next, Y_n_next, 'linear', 0));
            Y_n_next = Y_n_now + dt * 0.5 * (interp2(X, Y, V_n_now, X_n_now, Y_n_now, 'linear', 0) + interp2(X, Y, V_n_next, X_n_next, Y_n_next, 'linear', 0));
        end

        % Zeitschrittverfahren für die analytische Lösung
        X_a_next = X_a_now + dt * interp2(X, Y, U_a_now, X_a_now, Y_a_now, 'linear', 0);
        Y_a_next = Y_a_now + dt * interp2(X, Y, V_a_now, X_a_now, Y_a_now, 'linear', 0);

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
