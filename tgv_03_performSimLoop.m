function tgv_03_performSimLoop(X, Y, U_a, V_a, Psi_a, options)
    colors = tgv_initColors(Y, options);

    % Create differentiation matrices
    D1x = tgv_createD1Matrix(options, 'x');
    D1y = tgv_createD1Matrix(options, 'y');
    D2x = tgv_createD2Matrix(options, 'x');
    D2y = tgv_createD2Matrix(options, 'y');

    % Initialize particle positions
    X_pos = X;
    Y_pos = Y;
    X_pos_a = X;
    Y_pos_a = Y;

    % Initialize numerical variables
    U = U_a(0);
    V = V_a(0);
    Psi = Psi_a(0);

    % Ensure u and v are column vectors
    u = U(:);
    v = V(:);

    % Calculate initial vorticity using differentiation matrices
    dVdx = D1x * v;
    dUdy = D1y * u;
    omega = dVdx - dUdy;
    Omega = reshape(omega, [options.x_nr, options.y_nr]);

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

        % Update vorticity
        Omega = tgv_updateVorticity(U, V, Omega, D1x, D1y, D2x, D2y, options);

        % Solve Poisson equation for stream function
        Psi = tgv_poissonSolver(Omega, D2x, D2y);

        % Update velocities from stream function
        [U, V] = tgv_updateVelocity(Psi, D1x, D1y, options);

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
