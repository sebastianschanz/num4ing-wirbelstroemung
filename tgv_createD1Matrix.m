function D1 = tgv_createD1Matrix(options, direction)
    if strcmp(direction, 'x')
        N = options.x_nr;
        ds = options.dx;
    elseif strcmp(direction, 'y')
        N = options.y_nr;
        ds = options.dy;
    end
    
    e = ones(N, 1);
    % Zentraldifferenzen 1. Ordnung mit periodischen Randbedingungen
    T = spdiags([-e e], [-1 1], N, N) / (2 * ds);
    T(1, end) = -1 / (2 * ds); % Periodische BC
    T(end, 1) = 1 / (2 * ds); % Periodische BC
    
    % Kronecker Produkt für 2D-Matrix
    if strcmp(direction, 'x')
        I = speye(options.y_nr);
        D1 = kron(I, T);
    elseif strcmp(direction, 'y')
        I = speye(options.x_nr);
        D1 = kron(T, I);
    end
end
