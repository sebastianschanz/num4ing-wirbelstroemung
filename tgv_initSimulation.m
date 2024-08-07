function data = tgv_initSimulation(options)
    % Initialisierung der Simulationsvariablen für den Taylor-Green-Wirbel
    x = linspace(options.x_min, options.x_max, options.nx);
    y = linspace(options.y_min, options.y_max, options.ny);
    [X, Y] = meshgrid(x, y);
    data.X = X;   data.Y = Y;

    % Partikelpositionen initialisieren
    data.X_pos = X;   data.Y_pos = Y;   data.X_pos_a = X;   data.Y_pos_a = Y;

    % Zufällige Auswahl der Partikel für das Plotten der Bahnlinien
    numParticles = options.numParticles;
    totalParticles = numel(data.X_pos);
    data.particleIndices = randperm(totalParticles, numParticles);
    
    % Arrays zur Speicherung der Bahnlinien mehrerer Partikel
    data.traj_X_pos = cell(numParticles, 1);
    data.traj_Y_pos = cell(numParticles, 1);
    data.traj_X_pos_a = cell(numParticles, 1);
    data.traj_Y_pos_a = cell(numParticles, 1);

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

    % Definition des Boolschen Vektors für die Cauchy-Riemann Gleichung
    W = B;
    data.W = W;

    WH = false(options.nx, options.ny);
    WH(1, :) = true;     % Untere Wand
    WH(end, :) = true;   % Obere Wand
    data.WH = WH;

    WV = false(options.nx, options.ny);
    WV(:, 1) = true;     % Linke Wand
    WV(:, end) = true;   % Rechte Wand
    data.WV = WV;

    % Aufstellen und Zerlegen der Systemmatrix für die Poisson-Gleichung
    A = diag(~B(:)) * (D2x + D2y) + diag(B(:)); % ∇² = ∂²/∂x² + ∂²/∂y²
    [A_L, A_U] = lu(A);                         % LU-Zerlegung der Systemmatrix
    data.A_L = A_L;   data.A_U = A_U;
    
    % Analytische Lösung des Taylor-Green-Vortex
    U_a = @(t) sin(X) .* cos(Y) .* exp(-2 * options.nu * t);    % Analytische Geschwindigkeitskomponente U
    V_a = @(t) -cos(X) .* sin(Y) .* exp(-2 * options.nu * t);   % Analytische Geschwindigkeitskomponente V
    Psi_a = @(t) sin(X) .* sin(Y) .* exp(-2 * options.nu * t);  % Analytische Stromfunktion
    data.U_a = U_a;   data.V_a = V_a;   data.Psi_a = Psi_a;

    % Numerische Lösung mit analytischer vorinitialisieren
    U = U_a(0);                                 % U = sin(X) .* cos(Y) * F_t
    V = V_a(0);                                 % V = -cos(X) .* sin(Y) * F_t
    Psi = Psi_a(0);                             % ψ = sin(X) .* sin(Y) * F_t
    Omega_vec = -(D2x * Psi(:) + D2y * Psi(:)); % ω = -∇²ψ  
    Omega = reshape(Omega_vec, size(X));        % in Matrix umwandeln
    data.U = U;   data.V = V;   data.Psi = Psi;   data.Omega = Omega;

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
end