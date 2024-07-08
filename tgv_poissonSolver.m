function Psi = tgv_poissonSolver(Omega, D2x, D2y)
    % Lösen der Poisson-Gleichung mit periodischen Randbedingungen

    % Aufstellen der Systemmatrix
    A = D2x + D2y;
    
    % Fixing the singular matrix problem by modifying one equation (periodic BC)
    A(1, :) = 0; 
    A(1, 1) = 1; 
    b = -Omega(:);
    b(1) = 0; 
    
    % LU-Zerlegung der Systemmatrix
    [L, U] = lu(A);

    % Lösung des linearen Gleichungssystems A * Psi = b mit LU-Zerlegung
    y = L \ b;
    psi = U \ y;

    % Rücktransformation in Matrixform
    Psi = reshape(psi, size(Omega));
end
