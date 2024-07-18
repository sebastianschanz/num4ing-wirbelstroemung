function [D1x, D1y, D2x, D2y] = tgv_createDiffMatrices(options)
    % Erstellt die Ableitungsmatrizen D1x, D1y, D2x und D2y für die Lösung der Poisson- und Cauchy-Riemann-Gleichungen.
    nx = options.x_nr;
    ny = options.y_nr;
    dx = options.dx;
    dy = options.dy;

    % Laplace-Operator
    A = tgv_Laplace(nx, ny);

    % Nabla-Operatoren
    [DX, DY] = tgv_Nabla(nx, ny, dx);

    % Kronecker-Produkt verwenden, um auf 2D zu erweitern
    D1x = DX;
    D1y = DY;
    D2x = A / dx^2;
    D2y = A / dy^2;
end