%%% Projekt Wirbelströmung %%%     
%%%  TAYLOR-GREEN-WIRBEL   %%%

%%% Gruppe nm Y
%%% Fabian Schmitt              492849, 
%%% Leon Benjamin Wagner        498829, 
%%% Sebastian Schanz            482121,
%%% Tristan Johannes Schefold   489395

% Hauptfunktion zur Initialisierung und Ausführung der Simulation
function main()
    % Konfiguration der Simulation
    options = configureSimulation();
    % Initialisierung der Simulation
    [X, Y, Psi, Omega] = initSimulation(options);
    % Initialisierung der grafischen Darstellung
    [ax1, ax2] = initPlots(X, Y, Psi);
    % Durchführung der Zeitschleife zur Simulation der Partikelbewegung
    performTimeLoop(X, Y, Psi, Omega, options, ax1, ax2);
end

function options = configureSimulation()
    % Erstellung einer Struktur mit den Simulationsparametern
    options = struct('nu', 0.2, 't_end', 5, 't_nr', 100, 'x_nr', 100, 'y_nr', 100, 'method', 'adams-bashforth', 'colormap', 'parula');
end

function [X, Y, Psi, Omega] = initSimulation(options)
    % Erzeugung der Gitterpunkte
    x = linspace(0, 2*pi, options.x_nr);
    y = linspace(0, 2*pi, options.y_nr);
    [X, Y] = meshgrid(x, y);

    % Initialisierung der Stromfunktion und Wirbelstärke
    Psi = zeros(size(X));    
    Omega = -2 * sin(X) .* sin(Y); % Initial- Wirbelstärke für Taylor-Green-Wirbel
    
    % Lösung der Poisson-Gleichung für die Stromfunktion
    Psi = poissonSolver(Omega, options);
end

function [ax1, ax2] = initPlots(X, Y, Psi)
    % Erstellung eines neuen Diagramms für die Partikel
    figure; % Sicherstellen, dass ein neues Diagramm erstellt wird
    ax1 = subplot(1, 2, 1);
    scatter(ax1, X(:), Y(:), [], Y(:), 'filled'); % Verwendung von Y für die Farben
    xlim(ax1, [0 2*pi]);
    ylim(ax1, [0 2*pi]);
    title(ax1, 'Lagrange Partikel');
    xlabel(ax1, '$x$', 'Interpreter', 'latex');
    ylabel(ax1, '$y$', 'Interpreter', 'latex');
    colormap(ax1, 'jet'); % Setzen des Farbschemas auf 'jet'
    % colorbar(ax1); % Diese Zeile entfernt die Farbskala für die Partikel
    
    % Erstellung eines neuen 3D-Diagramms für die Stromfunktion
    ax2 = subplot(1, 2, 2);
    surf(ax2, X, Y, Psi, 'EdgeColor', 'none');
    % colorbar; % Diese Zeile entfernt die Farbskala für die Stromfunktion
    xlim(ax2, [0 2*pi]);
    ylim(ax2, [0 2*pi]);
    zMin = min(Psi(:));
    zMax = max(Psi(:));
    if zMin == zMax
        zMax = zMin + 1; % Kleine Anpassung, um unterschiedliche Werte zu haben
    end
    zlim(ax2, [zMin zMax]);
    title(ax2, 'Stromfunktion');
    xlabel(ax2, '$x$', 'Interpreter', 'latex');
    ylabel(ax2, '$y$', 'Interpreter', 'latex');
    zlabel(ax2, '$\Psi$', 'Interpreter', 'latex');
    colormap(ax2, 'jet'); % Setzen des Farbschemas auf 'jet'
    view(3); % 3D-Ansicht aktivieren
end

function colors = initColors(Y)
    % Normalisierung der Y-Koordinate für die Farben
    Y_norm = (Y - min(Y(:))) / (max(Y(:)) - min(Y(:)));
    colors = Y_norm;
end

function performTimeLoop(X, Y, Psi, Omega, options, ax1, ax2)
    % Initialisierung der Farben basierend auf der Y-Koordinate
    colors = initColors(Y); % Diese Funktion muss definiert werden

    % Erstellung des Zeitvektors für die Simulation
    time = linspace(0, options.t_end, options.t_nr);
    dt = time(2) - time(1);
    X_pos = X;
    Y_pos = Y;

    % Speicher für vorherige Werte (für Adams-Bashforth)
    Omega_prev = Omega;

    for t = time
        % Verwende die initialisierten Farben
        scatter(ax1, X_pos(:), Y_pos(:), [], colors(:), 'filled'); % Verwendung der initialen Farben basierend auf Y
        
        xlim(ax1, [0 2*pi]);
        ylim(ax1, [0 2*pi]);
        title(ax1, 'Lagrange Partikel');
        xlabel(ax1, '$x$', 'Interpreter', 'latex');
        ylabel(ax1, '$y$', 'Interpreter', 'latex');
        colormap(ax1, options.colormap); % Setzen des Farbschemas
        % colorbar(ax1); % Diese Zeile wurde entfernt
        
        % Lösung der Poisson-Gleichung für die Stromfunktion
        Psi = poissonSolver(Omega, options);

        % Umrechnung der Stromfunktion in die Geschwindigkeitskomponenten
        [U, V] = updateVelocity(Psi);

        % Berechnung der neuen Positionen der Partikel
        X_pos = X_pos + dt * interp2(X, Y, U, X_pos, Y_pos, 'linear', 0); % Interpolation der Geschwindigkeit U auf die Partikelpositionen
        Y_pos = Y_pos + dt * interp2(X, Y, V, X_pos, Y_pos, 'linear', 0); % Interpolation der Geschwindigkeit V auf die Partikelpositionen

        % Debug-Ausgabe der Partikelpositionen
        %fprintf('Zeit: %.2f, X_pos: %.5f, Y_pos: %.5f\n', t, mean(X_pos(:)), mean(Y_pos(:)));

        % Aktualisierung der Wirbelstärke
        if strcmp(options.method, 'adams-bashforth')
            Omega = updateVorticityAdamsBashforth(U, V, Omega, Omega_prev, options, dt);
        else
            Omega = updateVorticity(U, V, Omega, options, dt);
        end

        % Aktualisierung der Stromfunktion im Diagramm
        surf(ax2, X, Y, Psi, 'EdgeColor', 'none');
        % colorbar(ax2); % Diese Zeile entfernt die Farbskala für die Stromfunktion
        xlim(ax2, [0 2*pi]);
        ylim(ax2, [0 2*pi]);
        zMin = min(Psi(:));
        zMax = max(Psi(:));
        if zMin == zMax
            zMax = zMin + 1; % Kleine Anpassung, um unterschiedliche Werte zu haben
        end
        zlim(ax2, [zMin zMax]);
        title(ax2, 'Stromfunktion');
        xlabel(ax2, '$x$', 'Interpreter', 'latex');
        ylabel(ax2, '$y$', 'Interpreter', 'latex');
        zlabel(ax2, '$\Psi$', 'Interpreter', 'latex');
        colormap(ax2, options.colormap); % Setzen des Farbschemas
        view(3); % 3D-Ansicht aktivieren
        
        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');
        drawnow;

        % Debug-Ausgabe
        %fprintf('Zeit: %.2f, Min Psi: %.5f, Max Psi: %.5f\n', t, min(Psi(:)), max(Psi(:)));

        % Update previous values for Adams-Bashforth
        Omega_prev = Omega;
    end
end

function [U, V] = updateVelocity(Psi)
    % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion
    [dPsidx, dPsidy] = gradient(Psi);  % Berechnung der Gradienten der Stromfunktion
    U = -dPsidy;                       % Geschwindigkeit U aus der Stromfunktion
    V = dPsidx;                        % Geschwindigkeit V aus der Stromfunktion
end

function Omega = updateVorticity(U, V, Omega, options, dt)
    % Berechnung der neuen Wirbelstärke
    [dOmegadx, dOmegady] = gradient(Omega);
    laplacian_Omega = del2(Omega);        % Berechnung des Laplace-Operators der Wirbelstärke

    convection = U .* dOmegadx + V .* dOmegady; % Berechnung des Konvektionsterms
    diffusion = options.nu * laplacian_Omega;            % Berechnung des Diffusionsterms

    Omega = Omega + dt * (diffusion - convection);       % Aktualisierung der Wirbelstärke mit explizitem Euler-Schritt
end

function Omega = updateVorticityAdamsBashforth(U, V, Omega, Omega_prev, options, dt)
    % Berechnung der neuen Wirbelstärke mit Adams-Bashforth-Verfahren
    [dOmegadx, dOmegady] = gradient(Omega);
    laplacian_Omega = del2(Omega);        % Berechnung des Laplace-Operators der Wirbelstärke

    convection = U .* dOmegadx + V .* dOmegady; % Berechnung des Konvektionsterms
    diffusion = options.nu * laplacian_Omega;            % Berechnung des Diffusionsterms

    % Berechnung des neuen Omega-Werts
    Omega_new = Omega + dt * (diffusion - convection);

    % Adams-Bashforth 2. Ordnung
    if isempty(Omega_prev)
        Omega = Omega_new;
    else
        Omega = Omega + 0.5 * dt * (3 * (diffusion - convection) - (diffusion - convection));
    end
end

function P = poissonSolver(rhs, options)
    % Initialisierung des Druckfelds für die Poisson-Gleichung
    P = zeros(size(rhs));
    for iter = 1:100
        P_old = P;
        % Iterative Lösung der Poisson-Gleichung
        P = 0.25 * (circshift(P, [1, 0]) + circshift(P, [-1, 0]) + circshift(P, [0, 1]) + circshift(P, [0, -1]) - rhs);
        % Abbruchkriterium basierend auf der Konvergenz
        if max(max(abs(P - P_old))) < 1e-6
            break;
        end
    end
end

main();
