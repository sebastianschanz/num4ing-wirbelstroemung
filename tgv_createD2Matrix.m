function D2 = tgv_createD2Matrix(nx, ny, direction)
    if strcmp(direction, 'x')
        e = ones(nx, 1);
        h = 2 * pi / nx;
        % Differenzenmatrix für x-Richtung
        T = spdiags([e -2*e e], [-1 0 1], nx, nx) / (h^2);
        T(nx, 1) = 1 / (h^2); % Periodische Randbedingung (linker Rand)
        T(1, nx) = 1 / (h^2); % Periodische Randbedingung (rechter Rand)
        I = speye(ny);
        D2 = kron(I, T);
    elseif strcmp(direction, 'y')
        e = ones(ny, 1);
        h = 2 * pi / ny;
        % Differenzenmatrix für y-Richtung
        T = spdiags([e -2*e e], [-1 0 1], ny, ny) / (h^2);
        T(ny, 1) = 1 / (h^2); % Periodische Randbedingung (oberer Rand)
        T(1, ny) = 1 / (h^2); % Periodische Randbedingung (unterer Rand)
        I = speye(nx);
        D2 = kron(T, I);
    end
end
