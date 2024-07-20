function [D1x, D1y] = tgv_createNabla(options)
    % Erstellt die Differenzenmatrizen für die erste Ableitung in x- und y-Richtung
    % Tensormethode nach: https://www.math.uci.edu/~chenlong/226/FDMcode.pdf

    nx = options.nx;
    ny = options.ny;
    dx = options.dx;
    dy = options.dy;
    N = nx * ny; % Gesamtanzahl der Gitterpunkte

    % Speicherreservierung für die Differenzenmatrizen
    % Erstellt dünnbesetzte Matrizen D1x, D1y der Größe N x N mit 3 * N Elementen
    D1x = spalloc(N, N, 3 * N);
    D1y = spalloc(N, N, 3 * N);

    % Indizes für zentrale Differenzen
    e = ones(N, 1);

    % Zentrale Differenzen in x-Richtung
    D1x = spdiags([-e e], [-ny ny], N, N) / (2 * dx);

    % Zentrale Differenzen in y-Richtung
    D1y = spdiags([-e e], [-1 1], N, N) / (2 * dy);

    % Vorwärtsdifferenzen am linken Rand (erste Spalte)
    left_edge = (1:ny)';
    D1x(sub2ind([N, N], left_edge, left_edge)) = -1 / dx; % Setzt diagonales Element am rechten Rand von D1x auf -1/dx
    D1x(sub2ind([N, N], left_edge, left_edge + ny)) = 1 / dx; % Setzt Element rechts neben dem diagonalen Element auf 1/dx
    D1y(sub2ind([N, N], left_edge, left_edge)) = -1 / dy; % Setzt diagonales Element am rechten Rand von D1y auf -1/dy
    D1y(sub2ind([N, N], left_edge, left_edge + 1)) = 1 / dy; % Setzt Element rechts neben dem diagonalen Element auf 1/dy

    % Rückwärtsdifferenzen am rechten Rand (letzte Spalte)
    right_edge = (N - ny + 1:N)'; % N = 
    D1x(sub2ind([N, N], right_edge, right_edge)) = 1 / dx; % Setzt diagonales Element am rechten Rand von D1x auf 1/dx
    D1x(sub2ind([N, N], right_edge, right_edge - ny)) = -1 / dx; % Setzt Element links neben dem diagonalen Element auf -1/dx
    D1y(sub2ind([N, N], right_edge, right_edge)) = 1 / dy; % Setzt diagonales Element am rechten Rand von D1y auf 1/dy
    D1y(sub2ind([N, N], right_edge, right_edge - 1)) = -1 / dy; % Setzt Element links neben dem diagonalen Element auf -1/dy

    % Vorwärtsdifferenzen am unteren Rand (erste Zeile)
    bottom_edge = (1:nx:ny * nx)';
    D1y(sub2ind([N, N], bottom_edge, bottom_edge)) = -1 / dy; % Setzt diagonales Element am rechten Rand von D1y auf -1/dy
    D1y(sub2ind([N, N], bottom_edge, bottom_edge + 1)) = 1 / dy; % Setzt Element rechts neben dem diagonalen Element auf 1/dy

    % Rückwärtsdifferenzen am oberen Rand (letzte Zeile)
    top_edge = (ny:ny:N)';
    D1y(sub2ind([N, N], top_edge, top_edge)) = 1 / dy; % Setzt diagonales Element am rechten Rand von D1y auf 1/dy
    D1y(sub2ind([N, N], top_edge, top_edge - 1)) = -1 / dy; % Setzt Element links neben dem diagonalen Element auf -1/dy<s
end
