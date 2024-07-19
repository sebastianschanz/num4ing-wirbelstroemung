function [DX, DY] = tgv_Nabla(nx, ny, h)
    N = ny * nx;
    DX = spalloc(N, N, 4 * N); % Reserviert Speicherplatz für nicht-null Einträge
    DY = spalloc(N, N, 4 * N);

    % Zentrale Differenzen in x-Richtung (innen)
    DX = DX + spdiags([-ones(N, 1), ones(N, 1)], [-ny, ny], N, N);

    % Randbedingungen für x-Richtung (erste und letzte Zeile)
    first_row = (1:ny)';
    last_row = ((nx - 1) * ny + 1 : N)';

    % Erste Zeile
    DX(sub2ind([N, N], first_row, first_row)) = -3;
    valid = first_row + ny <= N;
    DX(sub2ind([N, N], first_row(valid), first_row(valid) + ny)) = 4;
    valid = first_row + 2 * ny <= N;
    DX(sub2ind([N, N], first_row(valid), first_row(valid) + 2 * ny)) = -1;

    % Letzte Zeile
    DX(sub2ind([N, N], last_row, last_row)) = 3;
    valid = last_row - ny > 0;
    DX(sub2ind([N, N], last_row(valid), last_row(valid) - ny)) = -4;
    valid = last_row - 2 * ny > 0;
    DX(sub2ind([N, N], last_row(valid), last_row(valid) - 2 * ny)) = 1;

    % Zentrale Differenzen in y-Richtung (innen)
    DY = DY + spdiags([-ones(N, 1), ones(N, 1)], [-1, 1], N, N);

    % Randbedingungen für y-Richtung (erste und letzte Spalte)
    first_col = (1:ny:N)';
    last_col = (ny:ny:N)';

    % Erste Spalte
    DY(sub2ind([N, N], first_col, first_col)) = -3;
    valid = first_col + 1 <= N;
    DY(sub2ind([N, N], first_col(valid), first_col(valid) + 1)) = 4;
    valid = first_col + 2 <= N;
    DY(sub2ind([N, N], first_col(valid), first_col(valid) + 2)) = -1;

    % Letzte Spalte
    DY(sub2ind([N, N], last_col, last_col)) = 3;
    valid = last_col - 1 > 0;
    DY(sub2ind([N, N], last_col(valid), last_col(valid) - 1)) = -4;
    valid = last_col - 2 > 0;
    DY(sub2ind([N, N], last_col(valid), last_col(valid) - 2)) = 1;

    % Normierung der Matrizen durch den Faktor 2 * h
    DX = DX / (2 * h);
    DY = DY / (2 * h);
end
