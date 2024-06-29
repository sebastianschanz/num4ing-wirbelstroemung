function Psi = calculatePsiBoundary(Psi, nx, ny)
    % Randbedingungen für Psi setzen
    Psi(1, :) = 0;      % unterer Rand
    Psi(end, :) = 0;    % oberer Rand
    Psi(:, 1) = 0;      % linker Rand
    Psi(:, end) = 0;    % rechter Rand
end
