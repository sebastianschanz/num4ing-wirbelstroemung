function D1 = tgv_createD1Matrix(options, direction)
    if strcmp(direction, 'x')
        N = options.x_nr;
        ds = options.dx;
    elseif strcmp(direction, 'y')
        N = options.y_nr;
        ds = options.dy;
    end
    
    e = ones(N, 1);
    % Central difference with periodic boundary conditions
    T = spdiags([-e e], [-1 1], N, N) / (2 * ds);
    T(1, end) = -1 / (2 * ds); % Periodic BC
    T(end, 1) = 1 / (2 * ds); % Periodic BC
    
    % Kronecker product for 2D extension
    if strcmp(direction, 'x')
        I = speye(options.y_nr);
        D1 = kron(I, T);
    elseif strcmp(direction, 'y')
        I = speye(options.x_nr);
        D1 = kron(T, I);
    end
end
