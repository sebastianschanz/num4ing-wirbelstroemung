function tgv_03_performSimLoop(X, Y, U_a, V_a, Psi_a, B, W, options)
    colors = tgv_initColors(Y, options); 

    % Partikelpositionen initialisieren
    X_pos = X;
    Y_pos = Y;
    X_pos_a = X;
    Y_pos_a = Y;

    % Erstellen der Ableitungsmatrizen D1x, D1y, D2x und D2y
    [D1x, D1y, D2x, D2y] = tgv_createDiffMatrices(options);

    % Aufstellen und Zerlegen der Systemmatrix für die Poisson-Gleichung
    A = diag(~B(:)) * (D2x + D2y) + diag(B(:)); % ∇² = ∂²/∂x² + ∂²/∂y²
    [A_L, A_U] = lu(A);                         % LU-Zerlegung der Systemmatrix

    % Numerische Lösung mit analytischer vorinitialisieren
    U = U_a(0);                                 % U = sin(X) .* cos(Y) * F_t
    V = V_a(0);                                 % V = -cos(X) .* sin(Y) * F_t
    Psi = Psi_a(0);                             % ψ = sin(X) .* sin(Y) * F_t
    Omega_vec = -(D2x * Psi(:) + D2y * Psi(:)); % ω = -∇²ψ  
    Omega = reshape(Omega_vec, size(X));        % in Matrix umwandeln

    fig = figure; % Figure für die Animation erstellen
    set(fig, 'Visible', 'off'); % Figure unsichtbar machen
    gif_filename = 'C:\Users\Sebastian\Documents\00-dev\num4ing\num4ing-wirbelstroemung\simulation.gif'; % GIF-Datei erstellen
    time = linspace(0, options.t_end, options.t_nr); % Zeitvektor erstellen

    for t = time
        tic;
        disp(['Aktueller Zeitschritt: ', num2str(t)]); % Aktuellen Zeitschritt ausgeben

        if ~isvalid(fig)
            break;
        end

        %%% ANALYTISCHE LÖSUNG %%%
        % Analytische Lösung für t aktualisieren
        U_a_now = U_a(t);
        V_a_now = V_a(t);
        Psi_a_now = Psi_a(t);

        % Partikelpositionen der analytischen Lösung aktualisieren
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a_now, V_a_now, X, Y, options);

        % Analytische Lösung plotten als Lagrange-Partikel und Stromfunktion
        tgv_plotData(subplot(2, 2, 3), X_pos_a, Y_pos_a, colors, 'scatter', 'Lagrange Partikel (Analytisch)', 'x', 'y', '', options);
        tgv_plotData(subplot(2, 2, 4), X, Y, Psi_a_now, 'surf', 'Stromfunktion (Analytisch)', 'x', 'y', '$\Psi$', options);

        %%% NUMERISCHE LÖSUNG %%%
        % Mit Wirbelstärke ω Poisson-Gleichung lösen, um die Stromfunktion ψ zu aktualisieren
        Psi = tgv_updateStream(Omega, A_L, A_U, Psi, B);

        % Geschwindigkeitsfeld U und V aktualisieren
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options);

        % Wirbelstärke ω aktualisieren
        Omega = tgv_updateVorticity(U, V, Omega, Psi, D1x, D1y, D2x, D2y, W, options);

        % Partikelpositionen aktualisieren
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options);
        X_pos = tgv_applyBC(X_pos, 'periodic');
        Y_pos = tgv_applyBC(Y_pos, 'periodic');

        % Numerische Lösung plotten als Lagrange-Partikel und Stromfunktion
        tgv_plotData(subplot(2, 2, 1), X_pos, Y_pos, colors, 'scatter', 'Lagrange Partikel (Numerisch)', 'x', 'y', '', options);
        tgv_plotData(subplot(2, 2, 2), X, Y, Psi, 'surf', 'Stromfunktion (Numerisch)', 'x', 'y', '$\Psi$', options);

        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');

        drawnow;

        % Capture the plot as an image and write it to the GIF
        frame = getframe(fig);
        img = frame2im(frame);
        [img_ind, cm] = rgb2ind(img, 256);
        if t == time(1)
            imwrite(img_ind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
        else
            imwrite(img_ind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
        end

        elapsedTime = toc;
        disp(['Berechnungszeit: ', num2str(elapsedTime), ' Sekunden']);
    end

    if isvalid(fig)
        close(fig);
    end
end
