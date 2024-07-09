function [X, Y, U_a, V_a, Psi_a] = tgv_02_initSimulation(options)
    % Initialisierung der Simulationsvariablen für den Taylor-Green-Wirbel
    x = linspace(options.x_min, options.x_max, options.x_nr);
    y = linspace(options.y_min, options.y_max, options.y_nr);
    [X, Y] = meshgrid(x, y);

    % Analytische Lösung des Taylor-Green-Vortex
    U_a = @(t) sin(X) .* cos(Y) .* exp(-2 * options.nu * t);
    V_a = @(t) -cos(X) .* sin(Y) .* exp(-2 * options.nu * t);
    Psi_a = @(t) sin(X) .* sin(Y) .* exp(-2 * options.nu * t);
end


%F_t = 1; % At t=0, F(t) = e^{-2*nu*0} = 1
%U = sin(X) .* cos(Y) * F_t; % Initiale Geschwindigkeit in x-Richtung
%V = -cos(X) .* sin(Y) * F_t; % Initial Geschwindigkeit in y-Richtung
%Omega = 2 * sin(X) .* sin(Y) * F_t; % Initiale Wirbelsträrke

%%%%%%%%%%%%%%%%%%%

%dx = 2 * pi / (options.x_nr - 1);
%dy = 2 * pi / (options.y_nr - 1);

% % Assuming U and V are defined on a grid with spacing dx and dy
%[~, dvdx] = gradient(V, dx, dy); % dvdx = ∂v/∂x
%[dudy, ~] = gradient(U, dx, dy); % dudy = ∂u/∂y
%Omega = dvdx - dudy; % Vorticity calculation