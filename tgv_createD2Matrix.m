function D2 = tgv_createD2Matrix(options, direction)
    if strcmp(direction, 'x')
        N = options.x_nr;
        ds = options.dx;
    elseif strcmp(direction, 'y')
        N = options.y_nr;
        ds = options.dy;
    end
    
    e = ones(N, 1);
    % Zentraldifferenzen 2. Ordnung mit periodischen Randbedingungen
    T = spdiags([e -2*e e], [-1 0 1], N, N) / (ds^2);
    T(1, end) = 1 / (ds^2); % Periodische BC
    T(end, 1) = 1 / (ds^2); % Periodische BC
    
    % Kronecker Produkt für 2D Erweiterung
    if strcmp(direction, 'x')
        I = speye(options.y_nr);
        D2 = kron(I, T);
    elseif strcmp(direction, 'y')
        I = speye(options.x_nr);
        D2 = kron(T, I);
    end
end
