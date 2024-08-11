function [D1xp, D1xm, D1yp, D1ym] = tgv_createNablaAufwind(options)
    % Erstellt die Differenzenmatrizen für die erste Ableitung in x- und y-Richtung
    % Tensormethode nach: https://www.math.uci.edu/~chenlong/226/FDMcode.pdf

    nx = options.nx;
    ny = options.ny;
    dx = options.dx;
    dy = options.dy;
    N = nx * ny; % Gesamtanzahl der Gitterpunkte

    % Speicherreservierung für die Differenzenmatrizen
    D1xp = spalloc(N, N, 2 * N);
    D1xm = spalloc(N, N, 2 * N);
    D1yp = spalloc(N, N, 2 * N);
    D1ym = spalloc(N, N, 2 * N);

    % Indizes für die Differenzen
    e = ones(N, 1);

    % Differenzen in x-Richtung
    D1xp = spdiags([-e e], [0 ny], N, N) / (dx);
    D1xm = spdiags([-e e], [-ny 0], N, N) / (dx);

    % Differenzen in x-Richtung
    D1yp = spdiags([-e e], [0 1], N, N) / (dy);
    D1ym = spdiags([-e e], [-1 0], N, N) / (dy);

    % Ränder
    left_edge = (1:ny)';
    right_edge = (N - ny + 1:N)';
    bottom_edge = (1:nx:ny * nx)';
    top_edge = (ny:ny:N)';

    % RB
    D1xp(sub2ind([N, N], left_edge, left_edge)) = -1 / dx;
    D1xp(sub2ind([N, N], left_edge, left_edge + ny)) = 1 / dx;

    D1xm(sub2ind([N, N], right_edge, right_edge)) = 1 / dx;
    D1xm(sub2ind([N, N], right_edge, right_edge - ny)) = -1 / dx;

    D1yp(sub2ind([N, N], top_edge, top_edge)) = -1 / dx;
    D1yp(sub2ind([N, N], top_edge, top_edge - 1)) = 1 / dx;

    D1ym(sub2ind([N, N], bottom_edge, bottom_edge)) = 1 / dx;
    D1ym(sub2ind([N, N], bottom_edge, bottom_edge + 1)) = -1 / dx;
end
