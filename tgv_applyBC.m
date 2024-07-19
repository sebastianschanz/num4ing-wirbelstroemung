function F = tgv_applyBC(F, boundary_type)
    % Randbedingungen je nach Typ anwenden
    switch boundary_type
        case 'periodic' % Periodische Randbedingungen für
            F(:, 1) = F(:, end-1); % linke und rechte Seite
            F(:, end) = F(:, 2); % linke und rechte Seite
            F(1, :) = F(end-1, :); % obere und untere Seite
            F(end, :) = F(2, :); % obere und untere Seite
        case 'dirichlet' % Dirichlet-Randbedingungen
            F(:, 1) = 0; % linke Seite
            F(:, end) = 0; % rechte Seite
            F(1, :) = 0; % obere Seite
            F(end, :) = 0; % untere Seite
        case 'neumann' % Neumann-Randbedingungen
            F(:, 1) = F(:, 2); % linke Seite
            F(:, end) = F(:, end-1); % rechte Seite
            F(1, :) = F(2, :); % obere Seite
            F(end, :) = F(end-1, :); % untere Seite
    end
end