function [DX, DY] = tgv_Nabla(nx, ny, h)
    N = ny * nx;
    DX = spalloc(N, N, 5*N); % Reserviert Speicherplatz für nicht-null Einträge
    DY = spalloc(N, N, 5*N);

    % Berechnung der x-Richtung Differenzen (DX)
    for m = 1:N
        % Randbedingung am Anfang (erste Zeile)
        if m <= ny
            DX(m, m) = -3; % Einseitige Differenz am Rand
            if m + ny <= N, DX(m, m + ny) = 4; end % Einseitige Differenz am Rand
            if m + 2 * ny <= N, DX(m, m + 2 * ny) = -1; end % Einseitige Differenz am Rand
        % Randbedingung am Ende (letzte Zeile)
        elseif m > (nx - 1) * ny
            DX(m, m) = 3; % Einseitige Differenz am Rand
            if m - ny > 0, DX(m, m - ny) = -4; end % Einseitige Differenz am Rand
            if m - 2 * ny > 0, DX(m, m - 2 * ny) = 1; end % Einseitige Differenz am Rand
        % Innerhalb des Gitters
        else
            if m - ny > 0, DX(m, m - ny) = -1; end % Zentrale Differenz
            if m + ny <= N, DX(m, m + ny) = 1; end % Zentrale Differenz
        end
    end

    % Berechnung der y-Richtung Differenzen (DY)
    for m = 1:N
        % Randbedingung am Anfang (erste Spalte)
        if mod(m, ny) == 1
            DY(m, m) = -3; % Einseitige Differenz am Rand
            if m + 1 <= N, DY(m, m + 1) = 4; end % Einseitige Differenz am Rand
            if m + 2 <= N, DY(m, m + 2) = -1; end % Einseitige Differenz am Rand
        % Randbedingung am Ende (letzte Spalte)
        elseif mod(m, ny) == 0
            DY(m, m) = 3; % Einseitige Differenz am Rand
            if m - 1 > 0, DY(m, m - 1) = -4; end % Einseitige Differenz am Rand
            if m - 2 > 0, DY(m, m - 2) = 1; end % Einseitige Differenz am Rand
        % Innerhalb des Gitters
        else
            if m - 1 > 0, DY(m, m - 1) = -1; end % Zentrale Differenz
            if m + 1 <= N, DY(m, m + 1) = 1; end % Zentrale Differenz
        end
    end

    % Normierung der Matrizen durch den Faktor 2 * h
    DX = DX / (2 * h);
    DY = DY / (2 * h);
end
