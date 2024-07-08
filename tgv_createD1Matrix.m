function D1 = tgv_createD1Matrix(nx, ny, direction)
    if strcmp(direction, 'x')
        e = ones(nx, 1);
        h = 2 * pi / nx;
        % Differenzenmatrix für x-Richtung
        T = spdiags([-e e], [-1 1], nx, nx) / (2 * h);
        T(1, end) = -1 / (2 * h); % Periodische Randbedingung (linker Rand)
        T(end, 1) = 1 / (2 * h); % Periodische Randbedingung (rechter Rand)
        I = speye(ny);
        D1 = kron(I, T);
    elseif strcmp(direction, 'y')
        e = ones(ny, 1);
        h = 2 * pi / ny;
        % Differenzenmatrix für y-Richtung
        T = spdiags([-e e], [-1 1], ny, ny) / (2 * h);
        T(end, 1) = -1 / (2 * h); % Periodische Randbedingung (oberer Rand)
        T(1, end) = 1 / (2 * h); % Periodische Randbedingung (unterer Rand)
        I = speye(nx);
        D1 = kron(T, I);
    end
end
