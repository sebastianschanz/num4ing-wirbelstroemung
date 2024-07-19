function [D1x, D1y] = tgv_createNabla(options)
    % Erstellt die Differenzenmatrizen für die erste Ableitung in x- und y-Richtung
    nx = options.nx;
    ny = options.ny;
    dx = options.dx;
    dy = options.dy;
    N = nx * ny; % Gesamtanzahl der Gitterpunkte

    % Speicherreservierung für die Differenzenmatrizen
    D1x = spalloc(N, N, 3 * N);
    D1y = spalloc(N, N, 3 * N);

    % Indizes für zentrale Differenzen
    e = ones(N, 1);

    % Zentrale Differenzen in x-Richtung
    D1x = spdiags([-e e], [-ny ny], N, N) / (2 * dx);

    % Zentrale Differenzen in y-Richtung
    D1y = spdiags([-e e], [-1 1], N, N) / (2 * dy);

    % Vorwärtsdifferenzen am linken Rand (erste Spalte)
    for i = 1:ny
        D1x(i, i) = -1 / dx;
        D1x(i, i + ny) = 1 / dx;
        if i <= ny
            D1y(i, i) = -1 / dy;
            D1y(i, i + 1) = 1 / dy;
        end
    end

    % Rückwärtsdifferenzen am rechten Rand (letzte Spalte)
    for i = N - ny + 1:N
        D1x(i, i) = 1 / dx;
        D1x(i, i - ny) = -1 / dx;
    end
    for i = ny:ny:N
        D1y(i, i) = 1 / dy;
        D1y(i, i - 1) = -1 / dy;
    end

    % Vorwärtsdifferenzen am unteren Rand (erste Zeile)
    for i = 1:nx:ny
        D1y(i, i) = -1 / dy;
        D1y(i, i + 1) = 1 / dy;
    end

    % Rückwärtsdifferenzen am oberen Rand (letzte Zeile)
    for i = N - ny + 1:N
        D1y(i, i) = 1 / dy;
        D1y(i, i - 1) = -1 / dy;
    end
end
