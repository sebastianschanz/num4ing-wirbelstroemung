function tgv_03_performSimLoop(X, Y, U_a, V_a, Psi_a, B, W, options)
    colors = tgv_initColors(Y, options);

    % Create differentiation matrices
    D1x = tgv_createD1Matrix(options, 'x');
    D1y = tgv_createD1Matrix(options, 'y');
    D2x = tgv_createD2Matrix(options, 'x');
    D2y = tgv_createD2Matrix(options, 'y');

    % Aufstellen der Systemmatrix für die Poisson-Gleichung
    A = diag(~B(:)) * (D2x + D2y) + diag(B(:)); % ∇²ψ

    % LU-Zerlegung der Systemmatrix
    [A_L, A_U] = lu(A);

    % Initialize particle positions
    X_pos = X;
    Y_pos = Y;
    X_pos_a = X;
    Y_pos_a = Y;

    % Numerische Lösung initialisieren
    U = U_a(0);
    V = V_a(0);
    Psi = Psi_a(0);

    % Spaltenvektoren aus den Geschwindigkeitsfeldern erstellen
    u = U(:);
    v = V(:);

    % Berechnung der initialen Wirbelstärke mit Ableitungsmatrizen D1x und D1y
    dVdx = D1x * v; % Partielle Ableitung von v nach x (v_x)
    dUdy = D1y * u; % Partielle Ableitung von u nach y (u_y)
    omega = dVdx - dUdy; % Wirbelstärke: ω_z = ∂v/∂x - ∂u/∂y
    Omega = reshape(omega, [options.x_nr, options.y_nr]); % Rücktransformation in Matrixform

    % Analytische Wirbelstärke
    % Omega_a = 2 * sin(X) .* sin(Y); % Analytische Wirbelstärke
    % Omega = Omega_a; % Initialisierung der Wirbelstärke

    fig = figure;

    for t = linspace(0, options.t_end, options.t_nr)
        tic;
        disp(['Aktueller Zeitschritt: ', num2str(t)]);

        if ~isvalid(fig)
            break;
        end

        % Update analytical solution
        U_a_now = U_a(t);
        V_a_now = V_a(t);
        Psi_a_now = Psi_a(t);

        % Update particle positions (analytical)
        [X_pos_a, Y_pos_a] = tgv_updatePosition(X_pos_a, Y_pos_a, U_a_now, V_a_now, X, Y, options);

        % Plot analytical solution
        tgv_plotData(subplot(2, 2, 3), X_pos_a, Y_pos_a, colors, 'scatter', 'Lagrange Partikel (Analytisch)', 'x', 'y', '', options);
        tgv_plotData(subplot(2, 2, 4), X, Y, Psi_a_now, 'surf', 'Stromfunktion (Analytisch)', 'x', 'y', '$\Psi$', options);

        % Update particle positions (numerical)
        [X_pos, Y_pos] = tgv_updatePosition(X_pos, Y_pos, U, V, X, Y, options);
        X_pos = tgv_applyBC(X_pos, 'periodic');
        Y_pos = tgv_applyBC(Y_pos, 'periodic');

        % Update vorticity
        Omega = tgv_updateVorticity(U, V, Omega, Psi, D1x, D1y, D2x, D2y, W, options);

        % Solve Poisson equation for stream function
        Psi = tgv_updateStream(Omega, A_L, A_U, Psi, B);

        % Update velocities from stream function
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, U, V, W, options);

        % Plot numerical solution
        tgv_plotData(subplot(2, 2, 1), X_pos, Y_pos, colors, 'scatter', 'Lagrange Partikel (Numerisch)', 'x', 'y', '', options);
        tgv_plotData(subplot(2, 2, 2), X, Y, Psi, 'surf', 'Stromfunktion (Numerisch)', 'x', 'y', '$\Psi$', options);

        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');

        drawnow;
        elapsedTime = toc;
        disp(['Berechnungszeit: ', num2str(elapsedTime), ' Sekunden']);
    end

    if isvalid(fig)
        close(fig);
    end
end
