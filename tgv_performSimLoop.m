function tgv_performSimLoop(data, options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation
    dt = options.dt;
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    X = data.X; Y = data.Y; D1x = data.D1x; D1y = data.D1y; D2x = data.D2x; D2y = data.D2y; B = data.B; WH = data.WH; WV = data.WV;
    X_n_trail = data.X_n_trail; Y_n_trail = data.Y_n_trail; X_a_trail = data.X_a_trail; Y_a_trail = data.Y_a_trail;
    D1xp = data.D1xp; D1xm = data.D1xm; D1yp = data.D1yp; D1ym = data.D1ym; % Aufwind Differenzenmatrizen
    particleIdx = data.particleIdx; A_L = data.A_L; A_U = data.A_U; U_a = data.U_a; V_a = data.V_a; Psi_a = data.Psi_a;
    Psi_bc = data.Psi_bc; colors = data.colors; fig = data.fig; enst_n = data.enst_n; enst_a = data.enst_a; energy_n = data.energy_n; energy_a = data.energy_a;

    for i = 1:length(time)
        if ~isvalid(fig) % Prüfen, ob die Figure noch existiert
            break;
        end
        t = time(i);
        tic;
        clf(fig); % Figure löschen, bevor neuer Frame gezeichnet wird
        
        % Aktuelle Variablen initialisieren
        if t == 0
            Psi_n_now = Psi_a(t); U_n_now = U_a(t); V_n_now = V_a(t); X_n_now = X; Y_n_now = Y;
            Omega_n_now = reshape(- (D2x + D2y) * Psi_n_now(:), size(X));
            Omega_dot_n_now = zeros(size(X));
            Psi_a_now = Psi_a(t); U_a_now = U_a(t); V_a_now = V_a(t); X_a_now = X; Y_a_now = Y;
        else
            Psi_n_now = Psi_n_next; U_n_now = U_n_next; V_n_now = V_n_next; Omega_n_now = Omega_n_next; Omega_dot_n_now = Omega_dot_n_next;
            X_n_now = X_n_next; Y_n_now = Y_n_next;     
            Psi_a_now = Psi_a_next; U_a_now = U_a_next; V_a_now = V_a_next; 
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
                [energy_n(i), enst_n(i)] = tgv_calcEnergy(Omega_n_now, U_n_now, V_n_now, options);
                [energy_a(i), enst_a(i)] = tgv_calcEnergy(Omega_a_now, U_a_now, V_a_now, options);
                % Plot der kinetischen Energie
                tgv_plotEnergy(subplot(2, 3, 6, 'Parent', fig), time(1:i), enst_n(1:i), enst_a(1:i), energy_n(1:i), energy_a(1:i), options);
                % disp([num2str(enst_n(i), '%.2f'), ' - Numerisch  |  ', num2str(enst_a(i), '%.2f'), ' - Analytisch']) - Ausgabe Enstrophie
            else
                % Erstellt einen Plot der Fehler der Stromfunktion
                tgv_plotStreamFunction(subplot(2, 3, 6, 'Parent', fig), X, Y, Psi_err, 'Differenz $\Psi_{err}=\Psi_{n}-\Psi_{a}$', 'x', 'y', '$\Psi_{err}$', options, 'autumn', [], [], [-1*options.nu 1*options.nu]);
                text(subplot(2, 3, 6, 'Parent', fig), 0, -0.23, ['MSE $\Psi_{err}$: ', sprintf('%.8f', psi_mse_err)], ...
                    'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                    'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');
            end
            if options.calcCFL
                % CFL-Felder berechnen
                CFLx = abs(U_n_now) .* dt ./ options.dx;
                CFLy = abs(V_n_now) .* dt ./ options.dy;
                CFLmax = max(max(CFLx,[],"all"), max(CFLy,[],"all"));
                disp("max. CFL = " + CFLmax);
            end
        end

        switch options.stepMethod
            case 'exEuler'
                subSteps = 1;
            case 'heun'
                subSteps = 2;
            case 'rk4'
                subSteps = 4;
            case 'imEuler'
                subSteps = 1;
            otherwise
                error('Unbekannte Integrationsmethode.');
        end

        % Erstelle cells für jede Variable für k_n
        Psi_n_k = cell(subSteps, 1);
        Omega_n_k = cell(subSteps, 1);
        Omega_dot_n_k = cell(subSteps, 1);
        X_n_k = cell(subSteps, 1);
        Y_n_k = cell(subSteps, 1);
        U_n_k = cell(subSteps, 1);
        V_n_k = cell(subSteps, 1);

        Psi_a_k = cell(subSteps, 1);
        X_a_k = cell(subSteps, 1);
        Y_a_k = cell(subSteps, 1);
        U_a_k = cell(subSteps, 1);
        V_a_k = cell(subSteps, 1);

        for n = 1:subSteps
            disp(['substep ', num2str(n), ' of ', num2str(subSteps)]);
            if n == 1
                U_n_k{n} = U_n_now;   V_n_k{n} = V_n_now; X_n_k{n} = X_n_now; Y_n_k{n} = Y_n_now;
                Omega_n_k{n} = Omega_n_now; Omega_dot_n_k{n} = Omega_dot_n_now; U_n_k{n} = U_n_now;   V_n_k{n} = V_n_now;                
                U_a_k{n} = U_a_now; V_a_k{n} = V_a_now; X_a_k{n} = X_a_now; Y_a_k{n} = Y_a_now;
            end
            
            [Psi_n_k{n+1}, U_n_k{n+1}, V_n_k{n+1}, Omega_dot_n_k{n+1}] = tgv_solveFlow(Omega_n_k{n}, Psi_bc, U_n_k{n}, V_n_k{n}, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, A_L, A_U, B, WH, WV, options);
            Psi_a_k{n+1} = Psi_a(t + n * dt); U_a_k{n+1} = U_a(t + n * dt); V_a_k{n+1} = V_a(t + n * dt);
            Omega_n_k{n+1} = Omega_n_k{n} + dt * Omega_dot_n_k{n};

            X_n_k{n+1} = X_n_k{n} + dt * interp2(X, Y, U_n_k{n}, X_n_k{n}, Y_n_k{n}, 'linear', 0);
            Y_n_k{n+1} = Y_n_k{n} + dt * interp2(X, Y, V_n_k{n}, X_n_k{n}, Y_n_k{n}, 'linear', 0);
            X_a_k{n+1} = X_a_k{n} + dt * interp2(X, Y, U_a_k{n}, X_a_k{n}, Y_a_k{n}, 'linear', 0);
            Y_a_k{n+1} = Y_a_k{n} + dt * interp2(X, Y, V_a_k{n}, X_a_k{n}, Y_a_k{n}, 'linear', 0);

            switch options.stepMethod
                case 'exEuler'
                    Omega_n_next = Omega_n_k{1} + dt * Omega_dot_n_k{1};
                    X_n_next = X_n_k{1} + dt * interp2(X, Y, U_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0);
                    Y_n_next = Y_n_k{1} + dt * interp2(X, Y, V_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0);
                    X_a_next = X_a_k{1} + dt * interp2(X, Y, U_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0);
                    Y_a_next = Y_a_k{1} + dt * interp2(X, Y, V_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0);
                case 'heun'
                    if n == subSteps
                        Omega_n_next = Omega_n_k{1} + dt/2 * (Omega_dot_n_k{1} + Omega_dot_n_k{2});
                        X_n_next = X_n_k{1} + dt/2 * (interp2(X, Y, U_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0) + interp2(X, Y, U_n_k{2}, X_n_k{2}, Y_n_k{2}, 'linear', 0));
                        Y_n_next = Y_n_k{1} + dt/2 * (interp2(X, Y, V_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0) + interp2(X, Y, V_n_k{2}, X_n_k{2}, Y_n_k{2}, 'linear', 0));
                        X_a_next = X_a_k{1} + dt/2 * (interp2(X, Y, U_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0) + interp2(X, Y, U_a_k{2}, X_a_k{2}, Y_a_k{2}, 'linear', 0));
                        Y_a_next = Y_a_k{1} + dt/2 * (interp2(X, Y, V_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0) + interp2(X, Y, V_a_k{2}, X_a_k{2}, Y_a_k{2}, 'linear', 0));
                    end
                case 'rk4'
                    if n == subSteps
                        Omega_n_next = Omega_n_k{1} + dt/6 * (Omega_dot_n_k{1} + 2 * Omega_dot_n_k{2} + 2 * Omega_dot_n_k{3} + Omega_dot_n_k{4});
                        X_n_next = X_n_k{1} + dt/6 * (interp2(X, Y, U_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0) + 2 * interp2(X, Y, U_n_k{2}, X_n_k{2}, Y_n_k{2}, 'linear', 0) + 2 * interp2(X, Y, U_n_k{3}, X_n_k{3}, Y_n_k{3}, 'linear', 0) + interp2(X, Y, U_n_k{4}, X_n_k{4}, Y_n_k{4}, 'linear', 0));
                        Y_n_next = Y_n_k{1} + dt/6 * (interp2(X, Y, V_n_k{1}, X_n_k{1}, Y_n_k{1}, 'linear', 0) + 2 * interp2(X, Y, V_n_k{2}, X_n_k{2}, Y_n_k{2}, 'linear', 0) + 2 * interp2(X, Y, V_n_k{3}, X_n_k{3}, Y_n_k{3}, 'linear', 0) + interp2(X, Y, V_n_k{4}, X_n_k{4}, Y_n_k{4}, 'linear', 0));
                        X_a_next = X_a_k{1} + dt/6 * (interp2(X, Y, U_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0) + 2 * interp2(X, Y, U_a_k{2}, X_a_k{2}, Y_a_k{2}, 'linear', 0) + 2 * interp2(X, Y, U_a_k{3}, X_a_k{3}, Y_a_k{3}, 'linear', 0) + interp2(X, Y, U_a_k{4}, X_a_k{4}, Y_a_k{4}, 'linear', 0));
                        Y_a_next = Y_a_k{1} + dt/6 * (interp2(X, Y, V_a_k{1}, X_a_k{1}, Y_a_k{1}, 'linear', 0) + 2 * interp2(X, Y, V_a_k{2}, X_a_k{2}, Y_a_k{2}, 'linear', 0) + 2 * interp2(X, Y, V_a_k{3}, X_a_k{3}, Y_a_k{3}, 'linear', 0) + interp2(X, Y, V_a_k{4}, X_a_k{4}, Y_a_k{4}, 'linear', 0));
                    end
                case 'imEuler'
                    % Implizites Euler-Verfahren mit Fixpunktiteration
                    Omega_n_next = Omega_n_k{n};  % Startwert als aktuellen Wert verwenden
                    
                    for iter = 1:options.maxIter
                        % Berechne die neue Schätzung für Omega_n_next
                        Omega_n_new = Omega_n_k{n} + dt * tgv_solveVorticity(U_n_k{n}, V_n_k{n}, Psi_bc, Omega_n_next, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, B, options);
                        
                        if norm(Omega_n_new - Omega_n_next, 'fro') < options.tol % Abbruchkriterium
                            break;
                        end
                        Omega_n_next = Omega_n_new; % Neue Schätzung als Startwert für die nächste Iteration verwenden
                    end
                    
                    % Berechnung des nächsten Schritts mit solveFlow
                    [Psi_n_k{2}, U_n_k{2}, V_n_k{2}, Omega_dot_n_k{2}] = tgv_solveFlow(Omega_n_next, Psi_bc, U_n_k{n}, V_n_k{n}, D1x, D1y, D1xp, D1xm, D1yp, D1ym, D2x, D2y, A_L, A_U, B, WH, WV, options);
            end
            Psi_n_next = Psi_n_k{2}; U_n_next = U_n_k{2}; V_n_next = V_n_k{2}; Omega_dot_n_next = Omega_dot_n_k{2};
            Psi_a_next = Psi_a_k{2}; U_a_next = U_a_k{2}; V_a_next = V_a_k{2};
        end   

        % Titel für die Figure aktualisieren
        sgtitle(['TGW Sim.', ', Integrationsmethode: ', options.stepMethod, ', $\nu=$', num2str(options.nu), ', t=', num2str(t, '%.2f')], 'Interpreter', 'latex', 'FontSize', options.imgScale*(options.fontSize+5));

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