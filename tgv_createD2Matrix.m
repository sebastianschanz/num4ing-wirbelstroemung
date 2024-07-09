function D2 = tgv_createD2Matrix(nx, ny, direction)
    % Diese Funktion erstellt die zweite Differenzenmatrix für die x- oder y-Richtung.
    if strcmp(direction, 'x')
        e = ones(nx, 1); % Vektor von Einsen
        h = 2 * pi / nx; % Schrittweite
        % Zweite Ableitungsmatrix für die x-Richtung
        T = spdiags([e -2*e e], [-1 0 1], nx, nx) / (h^2);
        T(nx, 1) = 1 / (h^2); % Periodische Randbedingung (linker Rand)
        T(1, nx) = 1 / (h^2); % Periodische Randbedingung (rechter Rand)
        I = speye(ny); % Einheitsmatrix
        D2 = kron(I, T); % Kronecker-Produkt zur Erweiterung auf 2D
    elseif strcmp(direction, 'y')
        e = ones(ny, 1); % Vektor von Einsen
        h = 2 * pi / ny; % Schrittweite
        % Zweite Ableitungsmatrix für die y-Richtung
        T = spdiags([e -2*e e], [-1 0 1], ny, ny) / (h^2);
        T(ny, 1) = 1 / (h^2); % Periodische Randbedingung (oberer Rand)
        T(1, ny) = 1 / (h^2); % Periodische Randbedingung (unterer Rand)
        I = speye(nx); % Einheitsmatrix
        D2 = kron(T, I); % Kronecker-Produkt zur Erweiterung auf 2D
    end
end
