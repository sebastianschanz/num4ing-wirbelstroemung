function [D2x, D2y] = tgv_createLaplace(options)
    % Erstellt die Differenzenmatrizen für die zweite Ableitung in x- und y-Richtung
    % Tensormethode nach: https://www.math.uci.edu/~chenlong/226/FDMcode.pdf
    
    nx = options.nx;
    ny = options.ny;
    dx = options.dx;
    dy = options.dy;
    N = nx * ny; % Gesamtanzahl der Gitterpunkte

    % Speicherreservierung für die Differenzenmatrizen
    % Erstellt dünnbesetzte Matrizen D2x, D2y der Größe N x N mit 5 * N Elementen
    D2x = spalloc(N, N, 5 * N);
    D2y = spalloc(N, N, 5 * N);

    % Indizes für zentrale Differenzen
    e = ones(N, 1);

    % Zweite zentrale Differenzen in x-Richtung
    D2x = spdiags([e -2*e e], [-ny 0 ny], N, N) / dx^2;

    % Zweite zentrale Differenzen in y-Richtung
    D2y = spdiags([e -2*e e], [-1 0 1], N, N) / dy^2;

    % Vorwärtsdifferenzen am linken Rand (erste Spalte)
    left_edge = (1:ny)';
    D2x(sub2ind([N, N], left_edge, left_edge)) = 1 / dx^2; % Setzt diagonales Element am rechten Rand von D2x auf 1/dx^2
    D2x(sub2ind([N, N], left_edge, left_edge + ny)) = -2 / dx^2; % Setzt Element rechts neben dem diagonalen Element auf -2/dx^2
    D2x(sub2ind([N, N], left_edge, left_edge + 2 * ny)) = 1 / dx^2; % Setzt Element rechts neben dem Element rechts neben dem diagonalen Element auf 1/dx^2
    D2y(sub2ind([N, N], left_edge, left_edge)) = 1 / dy^2; % Setzt diagonales Element am rechten Rand von D2y auf 1/dy^2
    D2y(sub2ind([N, N], left_edge, left_edge + 1)) = -2 / dy^2; % Setzt Element rechts neben dem diagonalen Element auf -2/dy^2
    D2y(sub2ind([N, N], left_edge, left_edge + 2)) = 1 / dy^2; % Setzt Element rechts neben dem Element rechts neben dem diagonalen Element auf 1/dy^2

    % Rückwärtsdifferenzen am rechten Rand (letzte Spalte)
    right_edge = (N - ny + 1:N)';
    D2x(sub2ind([N, N], right_edge, right_edge)) = 1 / dx^2; % Setzt diagonales Element am rechten Rand von D2x auf 1/dx^2
    D2x(sub2ind([N, N], right_edge, right_edge - ny)) = -2 / dx^2; % Setzt Element links neben dem diagonalen Element auf -2/dx^2
    D2x(sub2ind([N, N], right_edge, right_edge - 2 * ny)) = 1 / dx^2; % Setzt Element links neben dem Element links neben dem diagonalen Element auf 1/dx^2
    D2y(sub2ind([N, N], right_edge, right_edge)) = 1 / dy^2; % Setzt diagonales Element am rechten Rand von D2y auf 1/dy^2
    D2y(sub2ind([N, N], right_edge, right_edge - 1)) = -2 / dy^2; % Setzt Element links neben dem diagonalen Element auf -2/dy^2
    D2y(sub2ind([N, N], right_edge, right_edge - 2)) = 1 / dy^2; % Setzt Element links neben dem Element links neben dem diagonalen Element auf 1/dy^2

    % Vorwärtsdifferenzen am unteren Rand (erste Zeile)
    bottom_edge = (1:ny:N)';
    D2y(sub2ind([N, N], bottom_edge, bottom_edge)) = 1 / dy^2; % Setzt diagonales Element am rechten Rand von D2y auf 1/dy^2
    D2y(sub2ind([N, N], bottom_edge, bottom_edge + 1)) = -2 / dy^2; % Setzt Element rechts neben dem diagonalen Element auf -2/dy^2
    D2y(sub2ind([N, N], bottom_edge, bottom_edge + 2)) = 1 / dy^2; % Setzt Element rechts neben dem Element rechts neben dem diagonalen Element auf 1/dy^2

    % Rückwärtsdifferenzen am oberen Rand (letzte Zeile)
    top_edge = (ny:ny:N)';
    D2y(sub2ind([N, N], top_edge, top_edge)) = 1 / dy^2; % Setzt diagonales Element am rechten Rand von D2y auf 1/dy^2
    D2y(sub2ind([N, N], top_edge, top_edge - 1)) = -2 / dy^2; % Setzt Element links neben dem diagonalen Element auf -2/dy^2
    D2y(sub2ind([N, N], top_edge, top_edge - 2)) = 1 / dy^2; % Setzt Element links neben dem Element links neben dem diagonalen Element auf 1/dy^2
end
