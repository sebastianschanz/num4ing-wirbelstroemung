%%% Projekt Wirbelströmung %%%
%%% TAYLOR-GREEN-WIRBEL %%%

%%% Gruppe nm Y
%%% Fabian Schmitt 492849, 
%%% Leon Benjamin Wagner 498829, 
%%% Sebastian Schanz 482121,
%%% Tristan Johannes Schefold 489395

function main()
    % Hauptfunktion zur Initialisierung und Ausführung der Taylor-Green-Wirbel-Simulation
    options = configureSimulation();  % Simulationsparameter setzen
    [X, Y, Psi, Omega] = initSimulation(options);  % Simulationsvariablen initialisieren
    [ax1, ax2] = initPlots(X, Y, Psi, options);  % Plots initialisieren
    performTimeLoop(X, Y, Psi, Omega, options, ax1, ax2);  % Aktualisierungsschleife ausführen
end

function options = configureSimulation()
    options = struct('nu', 0.2, 't_end', 5, 't_nr', 100, 'x_nr', 100, 'y_nr', 100, 'method', 'expliziter-euler', 'colormap', 'parula');
end

function [X, Y, Psi, Omega] = initSimulation(options)
    % Initialisierung der Simulationsvariablen
    x = linspace(0, 2*pi, options.x_nr);  % Diskretisierung in x-Richtung
    y = linspace(0, 2*pi, options.y_nr);  % Diskretisierung in y-Richtung
    [X, Y] = meshgrid(x, y);  % Erzeugung des Gitters
    Omega = -2 * sin(X) .* sin(Y);  % Anfangsbedingung für Wirbelstärke (Taylor-Green-Wirbel)
    Psi = poissonSolver(Omega, options);  % Berechnung der Stromfunktion aus der Wirbelstärke
end

function [ax1, ax2] = initPlots(X, Y, Psi, options)
    % Initialisierung der Plots
    figure;
    ax1 = subplot(1, 2, 1);  % Erstes Plotfenster
    plotData(ax1, X, Y, Psi, 'scatter', 'Lagrange Partikel', options);  % Partikelplot
    ax2 = subplot(1, 2, 2);  % Zweites Plotfenster
    plotData(ax2, X, Y, Psi, 'surf', 'Stromfunktion', options);  % Stromfunktionplot
end

function performTimeLoop(X, Y, Psi, Omega, options, ax1, ax2)
    % Aktualisierungsschleife für die Simulation
    colors = initColors(Y);  % Farben für die Partikel initialisieren
    time = linspace(0, options.t_end, options.t_nr);  % Zeitdiskretisierung
    dt = time(2) - time(1);  % Zeitschrittgröße
    X_pos = X;  % Anfangsposition der Partikel in x-Richtung
    Y_pos = Y;  % Anfangsposition der Partikel in y-Richtung

    for t = time
        % 1. Plot der Lagrange-Partikel vor der Aktualisierung
        plotLagrangeParticles(ax1, X_pos, Y_pos, colors, options);  

        % 2. Berechnung der Stromfunktion aus der Wirbelstärke
        Psi = poissonSolver(Omega, options);  

        % 3. Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion
        [U, V] = updateVelocity(Psi);  

        % 4. Aktualisierung der Partikelpositionen
        [X_pos, Y_pos] = updateParticles(X_pos, Y_pos, U, V, dt, X, Y);  

        % 5. Aktualisierung der Wirbelstärke (Wirbeltransportgleichung)
        Omega = updateVorticity(U, V, Omega, options, dt);
        
        % 6. Anwendung der Randbedingungen auf die Wirbelstärke
        Omega = applyBoundaryConditions(Omega, 'Dirichlet');  

        % 7. Plot der Stromfunktion nach der Aktualisierung
        plotStreamFunction(ax2, X, Y, Psi, options);  

        sgtitle(['$\nu=', num2str(options.nu), ',~t=', num2str(t, '%.2f'), '$'], 'Interpreter', 'latex');  % Gesamttitel setzen
        drawnow;
    end
end

function Psi = poissonSolver(rhs, options)
    % Initialisierung des Druckfelds für die Poisson-Gleichung
    max_iter = 100;  % Maximale Anzahl an Iterationen zur Lösung der Poisson-Gleichung (Hinzugefügt)
    tol = 1e-12;  % Toleranz für das Abbruchkriterium (Hinzugefügt)
    Psi = zeros(size(rhs));
    for iter = 1:max_iter
        Psi_old = Psi;
        % Iterative Lösung der Poisson-Gleichung, um die 
        % Stromfunktion Psi aus der Wirbelstärke Omega zu berechnen
        Psi = 0.25 * (circshift(Psi, [1, 0]) + circshift(Psi, [-1, 0]) + circshift(Psi, [0, 1]) + circshift(Psi, [0, -1]) - rhs);
        Psi = applyBoundaryConditions(Psi, 'Dirichlet'); % Randbedingungen für Psi anwenden

        % Abbruchkriterium basierend auf der Konvergenz
        if max(max(abs(Psi - Psi_old))) < tol
            break;
        end
    end
end

function [X_pos, Y_pos] = updateParticles(X_pos, Y_pos, U, V, dt, X, Y)
    % Detaillierte Berechnung der Partikelpositionen
    X_pos = X_pos + dt * interp2(X, Y, U, X_pos, Y_pos, 'linear', 0);  % Partikelposition in x-Richtung aktualisieren
    Y_pos = Y_pos + dt * interp2(X, Y, V, X_pos, Y_pos, 'linear', 0);  % Partikelposition in y-Richtung aktualisieren

    % Periodische Randbedingungen anwenden
    X_pos = mod(X_pos, 2*pi);
    Y_pos = mod(Y_pos, 2*pi);
end

function [U, V] = updateVelocity(Psi)
    % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion Psi
    [dPsidx, dPsidy] = gradient(Psi);  % Berechnung der Gradienten der Stromfunktion
    U = -dPsidy;  % Geschwindigkeit U aus der Stromfunktion
    V = dPsidx;  % Geschwindigkeit V aus der Stromfunktion
end

function Omega = updateVorticity(U, V, Omega, options, dt)
    % Berechnung der neuen Wirbelstärke mithilfe der Wirbeltransportgleichung
    % unter Berücksichtigung von Konvektion und Diffusion
    [dOmegadx, dOmegady] = gradient(Omega);  % Gradienten der Wirbelstärke
    laplacian_Omega = del2(Omega); % Laplace-Operator der Wirbelstärke

    % Konvektionsterm: Transport der Wirbelstärke durch die Strömung
    convection = U .* dOmegadx + V .* dOmegady;
    
    % Diffusionsterm: Viskose Ausbreitung der Wirbelstärke
    diffusion = options.nu * laplacian_Omega;

    % Aktualisierung der Wirbelstärke (expliziter Euler-Schritt)
    Omega = Omega + dt * (diffusion - convection);
end

function plotData(ax, X, Y, data, plotType, titleText, options)
    % Plot-Funktion
    cla(ax);  % Aktuelles Plotfenster löschen
    if strcmp(plotType, 'scatter')
        scatter(ax, X(:), Y(:), [], Y(:), 'filled');  % Scatterplot der Partikel
    elseif strcmp(plotType, 'surf')
        surf(ax, X, Y, data, 'EdgeColor', 'none');  % Oberflächenplot der Daten
        zlim(ax, [min(data(:)), max(data(:)) + 1]);  % Z-Achsenlimits setzen
    end
    colormap(ax, options.colormap);  % Farbkarte einstellen
    setPlotProperties(ax, titleText, '$x$', '$y$', options);  % Plot-Eigenschaften setzen
end

function setPlotProperties(ax, titleText, xlabelText, ylabelText, options)
    % Plot-Einstellungen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);  % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex');  % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex');  % Y-Achsenbeschriftung
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    if isfield(options, 'zlabelText')
        zlabel(ax, options.zlabelText, 'Interpreter', 'latex');  % Z-Achsenbeschriftung (falls vorhanden)
    end
end

function plotLagrangeParticles(ax, X_pos, Y_pos, colors, options)
    % Plot der Lagrange-Partikel
    cla(ax);  % Aktuelles Plotfenster löschen
    scatter(ax, X_pos(:), Y_pos(:), [], colors(:), 'filled');  % Scatterplot der Partikel
    colormap(ax, options.colormap);  % Farbkarte einstellen
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    setPlotProperties(ax, 'Lagrange Partikel', '$x$', '$y$', options);  % Plot-Eigenschaften setzen
end

function plotStreamFunction(ax, X, Y, Psi, options)
    % Plot der Stromfunktion
    cla(ax);  % Aktuelles Plotfenster löschen
    surf(ax, X, Y, Psi, 'EdgeColor', 'none');  % Oberflächenplot der Stromfunktion
    colormap(ax, options.colormap);  % Farbkarte einstellen
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    zlim(ax, [min(Psi(:)), max(Psi(:)) + 1]);  % Z-Achsenlimits setzen
    setPlotProperties(ax, 'Stromfunktion', '$x$', '$y$', '$\Psi$');  % Plot-Eigenschaften setzen
    view(ax, 3);  % 3D-Ansicht
end

function colors = initColors(Y)
    % Farbinitialisierung für die Partikel
    num_repeats = 12;  % Anzahl der Wiederholungen des Farbverlaufs von 0 bis 2*pi
    Y_mod = mod(Y, 2*pi / num_repeats);  % Modulo-Operation für Wiederholung des Farbverlaufs
    Y_norm = (Y_mod - min(Y_mod(:))) / (max(Y_mod(:)) - min(Y_mod(:)));  % Normalisierung
    colors = round(Y_norm * 64);  % Farbskala anpassen (Annahme: colormap hat 64 Farben)
end

function F = applyBoundaryConditions(F, type)
    if nargin < 2
        type = 'Dirichlet';
    end
    
    switch type
        case 'Dirichlet'
            F(1, :) = 0;      % unterer Rand
            F(end, :) = 0;    % oberer Rand
            F(:, 1) = 0;      % linker Rand
            F(:, end) = 0;    % rechter Rand
        case 'Neumann'
            F(1, 2:end-1) = F(2, 2:end-1);      % unterer Rand
            F(end, 2:end-1) = F(end-1, 2:end-1); % oberer Rand
            F(2:end-1, 1) = F(2:end-1, 2);      % linker Rand
            F(2:end-1, end) = F(2:end-1, end-1); % rechter Rand
    end
end

main();

% Nächste Schritte:
% Numerische Verfahren: Nachdem die physikalische Berechnung des Taylor-Green-Wirbels korrekt ist, können verschiedene numerische Verfahren getestet werden. Dies könnte durch die Implementierung verschiedener Diskretisierungs- und Zeitschrittverfahren erfolgen (z.B. expliziter Euler, Runge-Kutta, Adams-Bashforth).
% Validierung: Es ist wichtig, die Ergebnisse mit analytischen Lösungen oder anderen verifizierten numerischen Ergebnissen zu vergleichen, um sicherzustellen, dass die Implementierung korrekt ist.
% Visualisierung: Zusätzliche Visualisierungen können hinzugefügt werden, um die Ergebnisse besser zu interpretieren und zu analysieren.
