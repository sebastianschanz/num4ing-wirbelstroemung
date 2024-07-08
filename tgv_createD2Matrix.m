function D2 = tgv_createD2Matrix(x_nr, y_nr, direction)
    % Erstellen der Differenzmatrix für zweite Ableitungen
    if strcmp(direction, 'x')
        e = ones(x_nr, 1);
        T = spdiags([e -2*e e], [-1 0 1], x_nr, x_nr);
        I = speye(y_nr);
        D2 = kron(I, T);
    elseif strcmp(direction, 'y')
        e = ones(y_nr, 1);
        T = spdiags([e -2*e e], [-1 0 1], y_nr, y_nr);
        I = speye(x_nr);
        D2 = kron(T, I);
    end
end