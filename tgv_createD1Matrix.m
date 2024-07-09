function D1 = tgv_createD1Matrix(nx, ny, direction)
    % Diese Funktion erstellt die erste Differenzenmatrix für die x- oder y-Richtung.
    if strcmp(direction, 'x')
        e = ones(nx, 1); % Vektor von Einsen
        h = 2 * pi / nx; % Schrittweite
        % Erste Ableitungsmatrix für die x-Richtung
        T = spdiags([-e e], [-1 1], nx, nx) / (2 * h);
        T(1, end) = -1 / (2 * h); % Periodische Randbedingung (linker Rand)
        T(end, 1) = 1 / (2 * h); % Periodische Randbedingung (rechter Rand)
        I = speye(ny); % Einheitsmatrix
        D1 = kron(I, T); % Kronecker-Produkt zur Erweiterung auf 2D
    elseif strcmp(direction, 'y')
        e = ones(ny, 1); % Vektor von Einsen
        h = 2 * pi / ny; % Schrittweite
        % Erste Ableitungsmatrix für die y-Richtung
        T = spdiags([-e e], [-1 1], ny, ny) / (2 * h);
        T(end, 1) = -1 / (2 * h); % Periodische Randbedingung (oberer Rand)
        T(1, end) = 1 / (2 * h); % Periodische Randbedingung (unterer Rand)
        I = speye(nx); % Einheitsmatrix
        D1 = kron(T, I); % Kronecker-Produkt zur Erweiterung auf 2D
    end
end
