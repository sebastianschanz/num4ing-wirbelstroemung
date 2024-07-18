function [A] = tgv_Laplace(nx, ny)
    % Diese Funktion erstellt die Laplace-Matrix A unter Verwendung der
    % Finite-Differenzen Methode für ein nx x ny Gitter.
    
    % Anzahl der Gitterpunkte
    N = nx * ny;
    
    % Diagonale Elemente
    main_diag = -4 * ones(N, 1);
    
    % Nebendiagonale Elemente
    side_diag = ones(N, 1);
    
    % Oberdiagonale und Unterdiagonale für y-Richtung
    upper_lower_diag_y = ones(N, 1);
    
    % Setze Null auf den Rändern der Matrix, um die Korrektheit der Randbedingungen sicherzustellen
    for i = 1:ny:N
        side_diag(i) = 0;
        if i > 1
            side_diag(i-1) = 0;
        end
    end
    
    % Konstruktion der Laplace-Matrix unter Verwendung der Diagonalen
    A = spdiags([upper_lower_diag_y, side_diag, main_diag, side_diag, upper_lower_diag_y], ...
                [-ny, -1, 0, 1, ny], N, N);
end