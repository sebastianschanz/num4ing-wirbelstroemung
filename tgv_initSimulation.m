function data = tgv_initSimulation(options)
    % Initialisierung der Simulationsvariablen für den Taylor-Green-Wirbel
    x = linspace(options.xMin, options.xMax, options.nx);
    y = linspace(options.yMin, options.yMax, options.ny);
    [X, Y] = meshgrid(x, y);
    data.X = X;   data.Y = Y;

    % Preallokation der Zeit, Energie und Enstrophie-Arrays
    data.time = zeros(1, options.maxIters);
    data.energy_n = NaN(1, options.maxIters);
    data.enst_n = NaN(1, options.maxIters);
    data.energy_a = NaN(1, options.maxIters);
    data.enst_a = NaN(1, options.maxIters);

    % Erstellen der Ableitungsmatrizen D1x, D1y, D2x und D2y
    [D1x, D1y] = tgv_createNabla(options);
    [D2x, D2y] = tgv_createLaplace(options);
    data.D1x = D1x;   data.D1y = D1y;   data.D2x = D2x;   data.D2y = D2y;

    % Definition des Boolschen Vektors für die Poisson-Gleichung
    B = false(options.nx, options.ny);
    B(:, 1) = true;     % Linke Wand
    B(:, end) = true;   % Rechte Wand
    B(1, :) = true;     % Untere Wand
    B(end, :) = true;   % Obere Wand
    data.B = B;

    % Neumann-Randbedingungen für die Geschwindigkeitskomponenten U und V
    WH = false(options.nx, options.ny);
    WH(1, :) = true;     % Untere Wand
    WH(end, :) = true;   % Obere Wand
    data.WH = WH;

    WV = false(options.nx, options.ny);
    WV(:, 1) = true;     % Linke Wand
    WV(:, end) = true;   % Rechte Wand
    data.WV = WV;

    % Kontinuitätsbedingung für Psi_bc
    Psi_bc = false(options.nx, options.ny);
    data.Psi_bc = Psi_bc;

    % Aufstellen und Zerlegen der Systemmatrix für die Poisson-Gleichung
    A = diag(~B(:)) * (D2x + D2y) + diag(B(:)); % ∇² = ∂²/∂x² + ∂²/∂y²
    [A_L, A_U] = lu(A);                         % LU-Zerlegung der Systemmatrix
    data.A_L = A_L;   data.A_U = A_U;
    
    % Analytische Lösung des Taylor-Green-Vortex
    U_a = @(t) sin(X) .* cos(Y) .* exp(-2 * options.nu * t);    % Analytische Geschwindigkeitskomponente U
    V_a = @(t) -cos(X) .* sin(Y) .* exp(-2 * options.nu * t);   % Analytische Geschwindigkeitskomponente V
    Psi_a = @(t) sin(X) .* sin(Y) .* exp(-2 * options.nu * t);  % Analytische Stromfunktion
    Omega_a = @(t) 2 * sin(X) .* sin(Y) .* exp(-2 * options.nu * t); % Analytische Rotation
    Omega_dot_a = @(t) -4 * sin(X) .* sin(Y) .* exp(-2 * options.nu * t) * options.nu; % Analytische Rotation
    data.U_a = U_a;   data.V_a = V_a;   data.Psi_a = Psi_a;   data.Omega_a = Omega_a;   data.Omega_dot_a = Omega_dot_a;
    
    colors = tgv_initColors(Y, options); % Farben für die Partikel initialisieren
    data.colors = colors;

    % Figure Parameter berechnen
    figWidth = options.imgScale*options.imgHeight*(0.5*options.calcErrors + 1); % Breite der Figure
    figHeight = options.imgScale*options.imgWidth; % Höhe der Figure
    screenSize = get(0, 'ScreenSize'); % Bildschirmgröße
    figPosX = (screenSize(3) - figWidth) / 2; % Position der Figure in x-Richtung
    figPosY = (screenSize(4) - figHeight) / 2; % Position der Figure in y-Richtung
    fig = figure('Units', 'pixels', 'Position', [figPosX, figPosY, figWidth, figHeight]); % Figure erstellen
    set(fig, 'Resize', 'off');
    data.fig = fig;
    if options.calcErrors
        data.title = 'Taylor-Green-Wirbel';
    else
        data.title = 'TGW';
    end
end