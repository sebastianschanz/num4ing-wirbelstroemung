function tgv_performSimLoop(data, options)
    % Funktion zur Ausführung der Aktualisierungsschleife der Taylor-Green-Wirbel-Simulation

    % Variablen aus data und options initialisieren
    X = data.X; Y = data.Y; U_a = data.U_a; V_a = data.V_a; Psi_a = data.Psi_a; Omega_a = data.Omega_a; Omega_dot_a = data.Omega_dot_a;
    colors = data.colors; fig = data.fig; enst_n = data.enst_n; enst_a = data.enst_a; energy_n = data.energy_n; energy_a = data.energy_a;
    time = data.time;

    % Iterationszähler, Zeitpunkt, Berechnungsdauer initialisieren
    i = 1;    t = 0;    elapsedTime = 0;

    % Hauptschleife für die Aktualisierung der Simulation
    while t < options.tEnd && i < options.maxIters
        % Prüfen, ob figure oder figure handle noch gültig ist
        if ~isvalid(fig)
            break;
        end
        % Step-Nummer und Zeitpunkt, sowie Zeitschrittgröße und aktuelle Berechnungsdauer ausgeben
        time = [time, t];   
        tic; % Berechnungsdauer starten

        clf(fig); % Figure löschen, bevor neuer Frame gezeichnet wird
        % Aktuelle Variablen initialisieren
        if t == 0
            % Initialisierung der Strömungsgrößen für den ersten Zeitschritt
            % Numerische Lösung
            Psi_n_now = Psi_a(0); U_n_now = U_a(0); V_n_now = V_a(0); X_n_now = X; Y_n_now = Y;
            Omega_n_now = Omega_a(0); Omega_dot_n_now = Omega_dot_a(0);
            % Analytische Lösung
            Psi_a_now = Psi_a(0); U_a_now = U_a(0); V_a_now = V_a(0); X_a_now = X; Y_a_now = Y;
            Omega_a_now = Omega_a(0); Omega_dot_a_now = Omega_dot_a(0);
        else
            % Aktualisierung der Strömungsgrößen für den nächsten Zeitschritt
            % Numerische Lösung
            Psi_n_now = Psi_n_next; U_n_now = U_n_next; V_n_now = V_n_next; Omega_n_now = Omega_n_next; Omega_dot_n_now = Omega_dot_n_next;
            X_n_now = X_n_next; Y_n_now = Y_n_next;    
            % Analytische Lösung
            Psi_a_now = Psi_a_next; U_a_now = U_a_next; V_a_now = V_a_next; Omega_a_now = Omega_a_next; % Omega_dot_a_now = Omega_dot_a_next;
            X_a_now = X_a_next; Y_a_now = Y_a_next;
        end

        % Plotten der Partikelbewegung und Stromfunktion der numerischen und analytischen Lösung
        tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 1, 'Parent', fig), X_n_now, Y_n_now, colors, 'Lagrange-Partikel (num.)', 'x', 'y', options);
        tgv_plotParticleField(subplot(2, 3 - ~options.calcErrors, 2, 'Parent', fig), X_a_now, Y_a_now, colors, 'Lagrange-Partikel (ana.)', 'x', 'y', options);
        tgv_plotStreamFunction(subplot(2, 3- ~options.calcErrors, 4 - ~options.calcErrors, 'Parent', fig), X, Y, Psi_n_now, 'Stromfunktion $\Psi_n$ (num.)', 'x', 'y', '$\Psi_n$', options);
        tgv_plotStreamFunction(subplot(2, 3 - ~options.calcErrors, 5 - ~options.calcErrors, 'Parent', fig), X, Y, Psi_a_now, 'Stromfunktion $\Psi_a$ (ana.)', 'x', 'y', '$\Psi_a$', options);

        if options.calcErrors
            % Berechnung der Fehler
            [pos_err_abs, ~, ~] = tgv_calcErrors(X_n_now, Y_n_now, X_a_now, Y_a_now, Psi_n_now, Psi_a_now);
            % Erstellt einen Boxplot der absoluten Positionsfehler
            pos_err_std = tgv_plotErrors(subplot(2, 3, 3, 'Parent', fig), pos_err_abs, 'Positionsfehler $|pos_{err}|$', options);
            % Plotten der Standardabweichung der absoluten Positionsfehler        
            text(subplot(2, 3, 3, 'Parent', fig), 0, -0.2, ['STD $|pos_{err}|$: ', sprintf('%.6f', pos_err_std)], ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'top', 'FontSize', options.imgScale*(options.fontSize), 'Interpreter', 'latex');
            % Berechnet Energie und Enstrophie der numerischen und analytischen Lösung
            [energy_n_i, enst_n_i] = tgv_calcEnerstrophy(Omega_n_now, U_n_now, V_n_now, options);
            [energy_a_i, enst_a_i] = tgv_calcEnerstrophy(Omega_a_now, U_a_now, V_a_now, options);

            energy_n = [energy_n, energy_n_i]; % Numerische Energie hinzufügen
            enst_n = [enst_n, enst_n_i]; % Numerische Enstrophie hinzufügen
            energy_a = [energy_a, energy_a_i]; % Analytische Energie hinzufügen
            enst_a = [enst_a, enst_a_i]; % Analytische Enstrophie hinzufügen
            % Plotten der Energie und Enstrophie
            tgv_plotEnerstrophy(subplot(2, 3, 6, 'Parent', fig), time, enst_n, enst_a, energy_n, energy_a, options);
        end

        % Optimale Zeitschrittgröße mit der maximalen CFL-Zahl berechnen
        if options.dynamicTimeSteps
            [options.dt, CFLmax] = tgv_calcCFLdt(U_n_now, V_n_now, options.dt, options);
        else
            [~, CFLmax] = tgv_calcCFLdt(U_n_now, V_n_now, options.dt, options);
        end
        

        switch options.stepMethod
            case 'Expliziter Euler'
                % Berechnung der Strömungsgrößen zum nächsten Zeitpunkt durch den expliziten Euler-Schritt
                [Omega_n_next, Omega_dot_n_next, Psi_n_next, U_n_next, V_n_next, X_n_next, Y_n_next] = tgv_solve_exEuler_step(Omega_n_now, Omega_dot_n_now, U_n_now, V_n_now, X_n_now, Y_n_now, data, options);
                [~, ~, ~, ~, ~, X_a_next, Y_a_next] = tgv_solve_exEuler_step(Omega_a_now, Omega_dot_a_now, U_a_now, V_a_now, X_a_now, Y_a_now, data, options);
            case 'Heun'
                % Berechnung der Strömungsgrößen zum nächsten Zeitpunkt durch das Heun-Verfahren
                [Omega_n_next, Omega_dot_n_next, Psi_n_next, U_n_next, V_n_next, X_n_next, Y_n_next] = tgv_solve_heun_step(Omega_n_now, Omega_dot_n_now, U_n_now, V_n_now, X_n_now, Y_n_now, data, options);
                [~, ~, ~, ~, ~, X_a_next, Y_a_next] = tgv_solve_heun_step(Omega_a_now, Omega_dot_a_now, U_a_now, V_a_now, X_a_now, Y_a_now, data, options);
            case 'Runge-Kutta 4'
                % Berechnung der Strömungsgrößen zum nächsten Zeitpunkt durch das Runge-Kutta-Verfahren 4. Ordnung
                [Omega_n_next, Omega_dot_n_next, Psi_n_next, U_n_next, V_n_next, X_n_next, Y_n_next] = tgv_solve_rk4_step(Omega_n_now, Omega_dot_n_now, U_n_now, V_n_now, X_n_now, Y_n_now, data, options);
                [~, ~, ~, ~, ~, X_a_next, Y_a_next] = tgv_solve_heun_step(Omega_a_now, Omega_dot_a_now, U_a_now, V_a_now, X_a_now, Y_a_now, data, options);
            otherwise
                error('Unbekannte Integrationsmethode.');
        end
        % Analytische Lösung für den nächsten Zeitschritt berechnen
        Psi_a_next = Psi_a(t); U_a_next = U_a(t); V_a_next = V_a(t); Omega_a_next = Omega_a(t); % Omega_dot_a_next = Omega_dot_a(t);

        % Titel für die Figure aktualisieren
        sgtitle([data.title, ', Methode: ', options.stepMethod, ', $\nu=$', num2str(options.nu), ', $t=$', num2str(t, '%.2f'), ', $dt=$', num2str(options.dt, '%.2f')], 'Interpreter', 'latex', 'FontSize', options.imgScale*(options.fontSize+5));

        drawnow; % Plsot aktualisieren
        if options.writeGif
            tgv_writeGifFrame(fig, t, options); % GIF-Frame schreiben
        end
        
        disp(['Step ', num2str(i), ', t = ', num2str(t, '%.2f'), ', dt = ', num2str(options.dt, '%.4f'), ', CFLmax = ', num2str(CFLmax, '%.4f'), ', Speed = ', num2str(elapsedTime, '%.2f')]);
        i = i + 1; % Iterationszähler inkrementieren
        t = t + options.dt; % Zeit inkrementieren
        elapsedTime = toc; % Berechnungsdauer stoppen
    end

    % Wenn figure oder figure handle nicht mehr gültig ist, schließen.
    if isvalid(fig)
        close(fig);
    end
end