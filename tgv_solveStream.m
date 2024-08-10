function Psi = tgv_solveStream(Omega, A_L, A_U, Psi_bc, B)
    % Lösung der Poisson-Gleichung für die Stromfunktion Ψ 
    % mit der vorgegebenen Verteilung der Wirbelstärke ω.

    % Vektorisierung der Matrizen
    omega = Omega(:); psi_bc = Psi_bc(:);

    % Rechte Seite der Poisson-Gleichung setzen
    b = ~B(:) .* (-omega) + B(:) .* psi_bc; % Rechte Seite der Poisson-Gleichung

    % Lösung des linearen Gleichungssystems Aψ = b mit LU-Zerlegung
    y = A_L \ b;
    psi = A_U \ y;

    % Rücktransformation in Matrixform
    Psi = reshape(psi, size(Omega));
end