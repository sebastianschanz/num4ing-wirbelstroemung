function [D2x, D2y] = tgv_createLaplace(options)
    % Erstellt die Differenzenmatrizen für die zweite Ableitung in x- und y-Richtung
    nx = options.nx;
    ny = options.ny;
    dx = options.dx;
    dy = options.dy;
    N = nx * ny; % Gesamtanzahl der Gitterpunkte

    % Speicherreservierung für die Differenzenmatrizen
    D2x = spalloc(N, N, 5 * N);
    D2y = spalloc(N, N, 5 * N);

    % Indizes für zentrale Differenzen
    e = ones(N, 1);

    % Zweite zentrale Differenzen in x-Richtung
    D2x = spdiags([e -2*e e], [-ny 0 ny], N, N) / dx^2;

    % Zweite zentrale Differenzen in y-Richtung
    D2y = spdiags([e -2*e e], [-1 0 1], N, N) / dy^2;

    % Vorwärtsdifferenzen am linken Rand (erste Spalte)
    for i = 1:ny
        D2x(i, i) = 1 / dx^2;
        D2x(i, i + ny) = -2 / dx^2;
        D2x(i, i + 2 * ny) = 1 / dx^2;
        if i <= ny
            D2y(i, i) = 1 / dy^2;
            D2y(i, i + 1) = -2 / dy^2;
            D2y(i, i + 2) = 1 / dy^2;
        end
    end

    % Rückwärtsdifferenzen am rechten Rand (letzte Spalte)
    for i = N - ny + 1:N
        D2x(i, i) = 1 / dx^2;
        D2x(i, i - ny) = -2 / dx^2;
        D2x(i, i - 2 * ny) = 1 / dx^2;
    end
    for i = ny:ny:N
        D2y(i, i) = 1 / dy^2;
        D2y(i, i - 1) = -2 / dy^2;
        D2y(i, i - 2) = 1 / dy^2;
    end

    % Vorwärtsdifferenzen am unteren Rand (erste Zeile)
    for i = 1:nx:ny
        D2y(i, i) = 1 / dy^2;
        D2y(i, i + 1) = -2 / dy^2;
        D2y(i, i + 2) = 1 / dy^2;
    end

    % Rückwärtsdifferenzen am oberen Rand (letzte Zeile)
    for i = N - ny + 1:N
        D2y(i, i) = 1 / dy^2;
        D2y(i, i - 1) = -2 / dy^2;
        D2y(i, i - 2) = 1 / dy^2;
    end
end
