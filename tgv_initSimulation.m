function [data] = tgv_initSimulation(options)
    % Initialisierung der Simulationsvariablen für den Taylor-Green-Wirbel
    x = linspace(options.x_min, options.x_max, options.nx);
    y = linspace(options.y_min, options.y_max, options.ny);
    [X, Y] = meshgrid(x, y);
    data.X = X;   data.Y = Y;

    % Partikelpositionen initialisieren
    data.X_pos = X;   data.Y_pos = Y;   data.X_pos_a = X;   data.Y_pos_a = Y;

    % Initialisierung der Bahnlinie eines Partikels
    data.traj_X_pos = [];   data.traj_Y_pos = [];  data.traj_X_pos_a = [];   data.traj_Y_pos_a = [];

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
end